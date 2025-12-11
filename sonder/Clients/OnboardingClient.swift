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
            
            let apiClient = DefaultAPIClient()
            let tokenClient = TokenClient()
            
            Task {
                await onboardingModel.loading()
                
                guard let tokens = try await apiClient.authenticateViaGoogle(token) else {
                    await onboardingModel.unauthenticated()
                    print("tokens returned nil in completeGoogleOAuth")
                    return
                }

                await tokenClient.storeTokens(with: onboardingModel, tokens: tokens)
                
                guard let accessToken = await tokenClient.loadAccessToken(with: onboardingModel) else {
                    print("accessToken is nil in task, implement solution to reassign token and store properly")
                    throw CancellationError()
                }
                
                print("from task: accessToken = \(accessToken!)")
                
                guard let user = try await apiClient.fetchUser(accessToken: accessToken!) else {
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
    
    func signOut(with onboardingModel: OnboardingModel) {
        let tokenClient = TokenClient()
        tokenClient.clearTokens(with: onboardingModel)
        GIDSignIn.sharedInstance.signOut()
        onboardingModel.unauthenticated()
    }
}
