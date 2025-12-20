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
    func completeGoogleOAuth(presentingVC: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                self.authModel.unauthenticated()
                return
            }
            
            guard let result = signInResult else {
                print("Google Sign-In: No result returned")
                self.authModel.unauthenticated()
                return
            }
            
            let token = result.user.accessToken.tokenString
            
            Task {
                await self.runOnboardingFlow() {

                    let tokens = try await self.apiClient.authenticateViaGoogle(token)
                    try await self.tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await self.tokenController.loadToken(as: .access)
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    await self.authModel.updateUser(user)
                    guard let circleID = await self.authModel.user?.circleID else {
                        await self.transition()
                        return
                    }
                    let circle = try await self.apiClient.fetchCircle(circleID, accessToken: accessToken)
                    await self.authModel.updateCircle(circle)
                    await self.transition()
                }
            }
            print("Google Sign-In succeeded for user: \(result.user.profile?.email ?? "<unknown>")")
        }
    }
    
    func restoreGoogleInstance() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { restoreResult, error in
            if let error = error {
                print("Google Restoration failed: \(error.localizedDescription)")
                self.authModel.unauthenticated()
                return
            }
            
            guard let result = restoreResult else {
                print("Google Sign-In: No result returned")
                self.authModel.unauthenticated()
                return
            }
            
            let token = result.accessToken.tokenString
            
            Task {
                await self.runOnboardingFlow() {
                    let tokens = try await self.apiClient.authenticateViaGoogle(token)
                    try await self.tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await self.tokenController.loadToken(as: .access)
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    await self.authModel.updateUser(user)
                    guard let circleID = await self.authModel.user?.circleID else {
                        await self.transition()
                        return
                    }
                    let circle = try await self.apiClient.fetchCircle(circleID, accessToken: accessToken)
                    await self.authModel.updateCircle(circle)
                    await self.transition()
                }
            }
        }
    }
    
    func onboardNewUser(firstName: String, lastName: String, email: String, username: String) {
        self.runOnboardingFlow() {
            let dto = UserDTO(email: email, firstName: firstName, lastName: lastName, username: username)
            self.authModel.updateUser(dto) // update within model to ensure that fields stay populated even if onboarding fails on server
            let accessToken = try self.tokenController.loadToken(as: .access)
            let user = try await self.apiClient.onboardNewUser(dto, accessToken: accessToken)
            self.authModel.updateUser(user)
            self.transition()
        }
    }
    
    func signOut() {
        do {
            try self.tokenController.clearTokens()
            GIDSignIn.sharedInstance.signOut()
            self.authModel.unauthenticated()
        } catch {
            self.handleOnboardingError(error)
        }
    }
}
