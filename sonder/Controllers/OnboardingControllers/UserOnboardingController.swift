//
//  UserOnboardingController.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI
import SonderDTOs
import GoogleSignIn

extension OnboardingController {
    func completeGoogleOAuth(with authModel: AuthModel, presentingVC: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                authModel.unauthenticated()
                return
            }
            
            guard let result = signInResult else {
                print("Google Sign-In: No result returned")
                authModel.unauthenticated()
                return
            }
            
            let token = result.user.accessToken.tokenString
            let tokenController = TokenController()
            
            Task {
                await self.runOnboardingFlow(with: authModel) {

                    let tokens = try await self.apiClient.authenticateViaGoogle(token)
                    try await tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await tokenController.loadToken(as: .access)
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    await authModel.updateUser(user)
                    await self.transition(with: authModel)
                }
            }
            print("Google Sign-In succeeded for user: \(result.user.profile?.email ?? "<unknown>")")
        }
    }
    
    func restoreGoogleInstance(with authModel: AuthModel) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { restoreResult, error in
            if let error = error {
                print("Google Restoration failed: \(error.localizedDescription)")
                authModel.unauthenticated()
                return
            }
            
            guard let result = restoreResult else {
                print("Google Sign-In: No result returned")
                authModel.unauthenticated()
                return
            }
            
            let token = result.accessToken.tokenString
            let tokenController = TokenController()
            
            Task {
                await self.runOnboardingFlow(with: authModel) {
                    let tokens = try await self.apiClient.authenticateViaGoogle(token)
                    try await tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await tokenController.loadToken(as: .access)
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    await authModel.updateUser(user)
                    await self.transition(with: authModel)
                }
            }
        }
    }
    
    func onboardNewUser(with authModel: AuthModel, firstName: String, lastName: String, email: String, username: String) {
        self.runOnboardingFlow(with: authModel) {
            let dto = UserDTO(email: email, firstName: firstName, lastName: lastName, username: username)
            authModel.updateUser(dto) // update within model to ensure that fields stay populated even if onboarding fails on server
            let tokenController = TokenController()
            let accessToken = try tokenController.loadToken(as: .access)
            let user = try await self.apiClient.onboardNewUser(dto, accessToken: accessToken)
            authModel.updateUser(user)
            self.transition(with: authModel)
        }
    }
    
    func signOut(with authModel: AuthModel) {
        do {
            let tokenController = TokenController()
            try tokenController.clearTokens()
            GIDSignIn.sharedInstance.signOut()
            authModel.unauthenticated()
        } catch {
            self.handleOnboardingError(with: authModel, error: error)
        }
    }
}
