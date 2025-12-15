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
    
    private func handleOnboardingError(with onboardingModel: OnboardingModel, error: Error) {
        switch error {
        case APIError.unauthorized:
            print("unauthorized error thrown in the api client")
            onboardingModel.unauthenticated()
        case APIError.interalServerError:
            print("internal server error thrown in the api client")
            onboardingModel.unauthenticated()
        case DecodingError.dataCorrupted:
            print("json data is corrupted in the api client")
            onboardingModel.unauthenticated()
        case TokenError.tokenDidNotStore:
            print("tokens did not store")
            onboardingModel.unauthenticated()
        case TokenError.tokenDidNotLoad:
            print("tokens did not load")
            onboardingModel.unauthenticated()
        case TokenError.tokenDidNotClear:
            print("tokens did not clear")
            onboardingModel.unauthenticated()
        default:
            print("unknown error has occured. figure out a way to pass name of error propagating")
            onboardingModel.unauthenticated()
        }
    }
    
    @MainActor
    private func runAuthFlow(with onboardingModel: OnboardingModel, restoringSession: Bool = false, _ operation: @escaping () async throws -> Void) {
        onboardingModel.loading()
        Task {
            do {
                try await operation()
            } catch {
                if restoringSession {
                    self.restoreGoogleInstance(with: onboardingModel)
                } else {
                    self.handleOnboardingError(with: onboardingModel, error: error)
                }
            }
        }
    }
    
    @MainActor
    private func transition(with onboardingModel: OnboardingModel, user: UserDTO, tokens: TokenResponseDTO? = nil) {
        guard let tokenInfo = tokens else {
            if user.circleID == nil {
                onboardingModel.status = .authenticatedNotInCircle
                return
            } else {
                onboardingModel.status = .authenticatedInCircle
                return
            }
        }
        
        if let userIsOnboarded = tokenInfo.userIsOnboarded {
            if !userIsOnboarded {
                onboardingModel.notOnboarded(user)
                return
            }
        }
            
        if let userInCircle = tokenInfo.userInCircle {
            if userInCircle {
                onboardingModel.authenticatedInCircle()
                return
            } else {
                onboardingModel.authenticatedNotInCircle()
                return
            }
        }
    }
    
    func startup(with onboardingModel: OnboardingModel) async {
        await restoreSession(with: onboardingModel)
    }
    
    func restoreSession(with onboardingModel: OnboardingModel) async {
        runAuthFlow(with: onboardingModel, restoringSession: true) {
            let tokenController = TokenController()
            let refreshToken = try tokenController.loadToken(as: .refresh)
            let tokens = try await self.apiClient.requestNewAccessToken(refreshToken: refreshToken)
            try tokenController.storeTokens(tokens: tokens)
            let accessToken = try tokenController.loadToken(as: .access)
            let user = try await self.apiClient.fetchUser(accessToken: accessToken)
            self.transition(with: onboardingModel, user: user, tokens: tokens)
        }
    }
    
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
                await self.runAuthFlow(with: onboardingModel) {

                    let tokens = try await self.apiClient.authenticateViaGoogle(token)
                    try await tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await tokenController.loadToken(as: .access)
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    await self.transition(with: onboardingModel, user: user, tokens: tokens)
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
                await self.runAuthFlow(with: onboardingModel) {
                    let tokens = try await self.apiClient.authenticateViaGoogle(token)
                    try await tokenController.storeTokens(tokens: tokens)
                    let accessToken = try await tokenController.loadToken(as: .access)
                    let user = try await self.apiClient.fetchUser(accessToken: accessToken)
                    await self.transition(with: onboardingModel, user: user, tokens: tokens)
                }
            }
        }
    }
    
    func onboardNewUser(with onboardingModel: OnboardingModel, firstName: String, lastName: String, email: String, username: String) async {
        self.runAuthFlow(with: onboardingModel) {
            let dto = UserDTO(email: email, firstName: firstName, lastName: lastName, username: username)
            let tokenController = TokenController()
            let accessToken = try tokenController.loadToken(as: .access)
            let user = try await self.apiClient.onboardNewUser(dto, accessToken: accessToken)
            self.transition(with: onboardingModel, user: user)
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
