//
//  OnboardingClient.swift
//  sonder
//
//  Created by Bryan Sample on 12/10/25.
//

import SwiftUI
import SonderDTOs
import GoogleSignIn

final class OnboardingClient {
    
    private let apiClient = DefaultAPIClient()
    
    init() { }
    
    func startup() {
        restoreSession()
    }
    
    func restoreSession() {
        /*
         
         fetch tokens
         validate tokens with server
         if valid {
            authenticateUser
            check if user in circle
            set correct status
         } elif invalid {
            set status = unauthenticated
         }
         
         if no tokens {
            restore google session
            if works, reissue tokens
            if not, unauthenticated
         }
         
         */
    }
    
    func completeGoogleOAuth(with onboardingModel: OnboardingModel, presentingVC: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
                // Handle the error without throwing
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            
            guard let result = signInResult else {
                print("Google Sign-In: No result returned")
                return
            }
            
            let token = result.user.accessToken.tokenString
            
            let tokenClient = TokenClient()
            
            Task {
                await onboardingModel.loading()
                
                guard let tokens = try await self.apiClient.authenticateViaGoogle(token) else {
                    await onboardingModel.unauthenticated()
                    print("tokens returned nil in completeGoogleOAuth")
                    return
                }

                await tokenClient.storeTokens(tokens: tokens)
                
                guard let accessToken = await tokenClient.loadAccessToken() else {
                    print("accessToken is nil in task, implement solution to reassign token and store properly")
                    return
                }
                
                print("from task: accessToken = \(accessToken!)")
                
                guard let user = try await self.apiClient.fetchUser(accessToken: accessToken!) else {
                    print("user info is nil in taks, implement solution to receive data accurately from server")
                    return
                }
                
                print("from task: user = \(user)")

                if let needsOnboarding = tokens.userNeedsToBeOnboarded {
                    if needsOnboarding {
                        await onboardingModel.notOnboarded(user)
                        return
                        // return from task to main thread
                    }
                }
                    
                if let userInCircle = tokens.userInCircle {
                    if userInCircle {
                        await onboardingModel.authenticatedInCircle()
                        return
                        // return from task to main thread
                    } else {
                        await onboardingModel.authenticatedNotInCircle()
                        return
                        // return from task to main thread
                    }
                }
            }
            
            print("Google Sign-In succeeded for user: \(result.user.profile?.email ?? "<unknown>")")
            
            
        }
    }
    
    func restoreGoogleInstance(with onboardingModel: OnboardingModel) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let info = user {
                print("Session restored user = \(info.profile!.email)")
                onboardingModel.status = .unauthenticated
                return
            }
            if let err = error {
                print(err)
                onboardingModel.status = .unauthenticated
                return
            }
        }
    }
    
    func onboardNewUser(with onboardingModel: OnboardingModel, firstName: String, lastName: String, email: String, username: String) async throws {
        onboardingModel.status = .loading
        
        let user = UserDTO(email: email, firstName: firstName, lastName: lastName, username: username)
        
        let tokenClient = TokenClient()
        
        guard let accessToken = tokenClient.loadAccessToken() else {
            print("accessToken not loaded in onboard new user")
            return
        }
        
        print("access token loaded")
        
        guard let user = try await apiClient.onboardNewUser(user, accessToken: accessToken!) else {
            print("user not loaded in onboardNewUsr")
            return
        }
        
        if user.circleID == nil {
            onboardingModel.status = .authenticatedNotInCircle
        } else {
            onboardingModel.status = .authenticatedInCircle
        }
        
    }
    
    func signOut(with onboardingModel: OnboardingModel) {
        let tokenClient = TokenClient()
        tokenClient.clearTokens()
        GIDSignIn.sharedInstance.signOut()
        onboardingModel.unauthenticated()
    }
}
