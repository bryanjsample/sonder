//
//  OnboardingController.swift
//  sonder
//
//  Created by Bryan Sample on 12/10/25.
//

import SwiftUI
import SonderDTOs
import GoogleSignIn

final class OnboardingController {
    
    private let apiClient = DefaultAPIClient()
    
    init() { }
    
    func startup(with onboardingModel: OnboardingModel) async {
        await restoreSession(with: onboardingModel)
    }
    
    func restoreSession(with onboardingModel: OnboardingModel) async {
        onboardingModel.loading()
        
        let tokenController = TokenController()
        
        do {
            let refreshToken = try tokenController.loadToken(as: .refresh)
            let tokens = try await self.apiClient.requestNewAccessToken(refreshToken: refreshToken)
            try tokenController.storeTokens(tokens: tokens)
            let accessToken = try tokenController.loadToken(as: .access)
            let user = try await self.apiClient.fetchUser(accessToken: accessToken)
            
            if let userIsOnboarded = tokens.userIsOnboarded {
                if !userIsOnboarded {
                    onboardingModel.notOnboarded(user)
                    return
                    // return from task to main thread
                }
            }
                
            if let userInCircle = tokens.userInCircle {
                if userInCircle {
                    onboardingModel.authenticatedInCircle()
                    return
                    // return from task to main thread
                } else {
                    onboardingModel.authenticatedNotInCircle()
                    return
                    // return from task to main thread
                }
            }
        } catch {
            self.restoreGoogleInstance(with: onboardingModel)
        }
        
    }
    
    func completeGoogleOAuth(with onboardingModel: OnboardingModel, presentingVC: UIViewController) {
        onboardingModel.loading()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
                // Handle the error without throwing
                print("Google Sign-In failed: \(error.localizedDescription)")
                onboardingModel.unauthenticated()
                return
            }
            
            guard let result = signInResult else {
                print("Google Sign-In: No result returned")
                onboardingModel.unauthenticated()
                return
            }
            
            let token = result.user.accessToken.tokenString
            let tokenController = TokenController()
            
            Task {
                
                do {
                    let tokens = try await self.apiClient.authenticateViaGoogle(token) // else model.unauth
                    try await tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await tokenController.loadToken(as: .access)
                    
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    
                    if let userIsOnboarded = tokens.userIsOnboarded {
                        if !userIsOnboarded {
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
                } catch APIError.unauthorized {
                    print("unauthorized error thrown in the api client")
                    await onboardingModel.unauthenticated()
                } catch APIError.interalServerError {
                    print("internal server error thrown in the api client")
                    await onboardingModel.unauthenticated()
                } catch DecodingError.dataCorrupted {
                    print("json data is corrupted in the api client")
                    await onboardingModel.unauthenticated()
                } catch TokenError.tokenDidNotStore {
                    print("tokens did not store")
                    await onboardingModel.unauthenticated()
                } catch TokenError.tokenDidNotLoad {
                    print("tokens did not load")
                    await onboardingModel.unauthenticated()
                } catch TokenError.tokenDidNotClear {
                    print("tokens did not clear")
                    await onboardingModel.unauthenticated()
                } catch {
                    print("unknown error has occured. figure out a way to pass name of error propagating")
                    await onboardingModel.unauthenticated()
                }
            }
            
            print("Google Sign-In succeeded for user: \(result.user.profile?.email ?? "<unknown>")")
            
            
        }
    }
    
    func restoreGoogleInstance(with onboardingModel: OnboardingModel) {
        onboardingModel.loading()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { restoreResult, error in
            
            if let error = error {
                // Handle the error without throwing
                print("Google Restoration failed: \(error.localizedDescription)")
                onboardingModel.unauthenticated()
                return
            }
            
            guard let result = restoreResult else {
                print("Google Sign-In: No result returned")
                onboardingModel.unauthenticated()
                return
            }
            
            let token = result.accessToken.tokenString
            let tokenController = TokenController()
            
            Task {
                
                do {
                    let tokens = try await self.apiClient.authenticateViaGoogle(token) // else model.unauth
                    try await tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await tokenController.loadToken(as: .access)
                    
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    
                    if let userIsOnboarded = tokens.userIsOnboarded {
                        if !userIsOnboarded {
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
                } catch APIError.unauthorized {
                    print("unauthorized error thrown in the api client")
                    await onboardingModel.unauthenticated()
                } catch APIError.interalServerError {
                    print("internal server error thrown in the api client")
                    await onboardingModel.unauthenticated()
                } catch DecodingError.dataCorrupted {
                    print("json data is corrupted in the api client")
                    await onboardingModel.unauthenticated()
                } catch TokenError.tokenDidNotStore {
                    print("tokens did not store")
                    await onboardingModel.unauthenticated()
                } catch TokenError.tokenDidNotLoad {
                    print("tokens did not load")
                    await onboardingModel.unauthenticated()
                } catch TokenError.tokenDidNotClear {
                    print("tokens did not clear")
                    await onboardingModel.unauthenticated()
                } catch {
                    print("unknown error has occured. figure out a way to pass name of error propagating")
                    await onboardingModel.unauthenticated()
                }
            }
        }
    }
    
    func onboardNewUser(with onboardingModel: OnboardingModel, firstName: String, lastName: String, email: String, username: String) async {
        onboardingModel.loading()
        do {
            let dto = UserDTO(email: email, firstName: firstName, lastName: lastName, username: username)
            let tokenController = TokenController()
            let accessToken = try tokenController.loadToken(as: .access)
            let user = try await self.apiClient.onboardNewUser(dto, accessToken: accessToken)
            
            if user.circleID == nil {
                onboardingModel.status = .authenticatedNotInCircle
            } else {
                onboardingModel.status = .authenticatedInCircle
            }
        } catch APIError.unauthorized {
            print("unauthorized error thrown in the api client")
            onboardingModel.unauthenticated()
        } catch APIError.interalServerError {
            print("internal server error thrown in the api client")
            onboardingModel.unauthenticated()
        } catch DecodingError.dataCorrupted {
            print("json data is corrupted in the api client")
            onboardingModel.unauthenticated()
        } catch TokenError.tokenDidNotStore {
            print("tokens did not store")
            onboardingModel.unauthenticated()
        } catch TokenError.tokenDidNotLoad {
            print("tokens did not load")
            onboardingModel.unauthenticated()
        } catch TokenError.tokenDidNotClear {
            print("tokens did not clear")
            onboardingModel.unauthenticated()
        } catch {
            print("unknown error has occured. figure out a way to pass name of error propagating")
            onboardingModel.unauthenticated()
        }
    }
    
    func signOut(with onboardingModel: OnboardingModel) {
        do {
            let tokenController = TokenController()
            try tokenController.clearTokens()
            GIDSignIn.sharedInstance.signOut()
            onboardingModel.unauthenticated()
        } catch TokenError.tokenDidNotClear {
            print("tokens did not clear when signing out figure out a way to try again")
            onboardingModel.unauthenticated()
        } catch {
            print("unknown error has occured. figure out a way to pass name of error propagating")
            onboardingModel.unauthenticated()
        }
    }
}
