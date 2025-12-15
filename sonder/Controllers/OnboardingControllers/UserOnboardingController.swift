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
    func completeGoogleOAuth(with onboardingModel: OnboardingModel, presentingVC: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
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
                await self.runOnboardingFlow(with: onboardingModel) {

                    let tokens = try await self.apiClient.authenticateViaGoogle(token)
                    try await tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await tokenController.loadToken(as: .access)
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    await onboardingModel.updateUser(user)
                    await self.transition(with: onboardingModel)
                }
            }
            print("Google Sign-In succeeded for user: \(result.user.profile?.email ?? "<unknown>")")
        }
    }
    
    func restoreGoogleInstance(with onboardingModel: OnboardingModel) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { restoreResult, error in
            if let error = error {
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
                await self.runOnboardingFlow(with: onboardingModel) {
                    let tokens = try await self.apiClient.authenticateViaGoogle(token)
                    try await tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await tokenController.loadToken(as: .access)
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    await onboardingModel.updateUser(user)
                    await self.transition(with: onboardingModel)
                }
            }
        }
    }
    
    func onboardNewUser(with onboardingModel: OnboardingModel, firstName: String, lastName: String, email: String, username: String) {
        self.runOnboardingFlow(with: onboardingModel) {
            let dto = UserDTO(email: email, firstName: firstName, lastName: lastName, username: username)
            onboardingModel.updateUser(dto) // update within model to ensure that fields stay populated even if onboarding fails on server
            let tokenController = TokenController()
            let accessToken = try tokenController.loadToken(as: .access)
            let user = try await self.apiClient.onboardNewUser(dto, accessToken: accessToken)
            onboardingModel.updateUser(user)
            self.transition(with: onboardingModel)
        }
    }
    
    func signOut(with onboardingModel: OnboardingModel) {
        do {
            let tokenController = TokenController()
            try tokenController.clearTokens()
            GIDSignIn.sharedInstance.signOut()
            onboardingModel.unauthenticated()
        } catch {
            self.handleOnboardingError(with: onboardingModel, error: error)
        }
    }
}
