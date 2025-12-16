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
    
    let apiClient = DefaultAPIClient()
    
    init() { }
    
    func handleOnboardingError(with authModel: AuthModel, error: Error) {
        switch error {
        case APIError.badRequest:
            print("badRequest error thrown in the api client")
            authModel.notOnboarded()
        case APIError.unauthorized:
            print("unauthorized error thrown in the api client")
            authModel.unauthenticated()
        case APIError.interalServerError:
            print("internal server error thrown in the api client")
            authModel.unauthenticated()
        case DecodingError.dataCorrupted:
            print("json data is corrupted in the api client")
            authModel.unauthenticated()
        case TokenError.tokenDidNotStore:
            print("tokens did not store")
            authModel.unauthenticated()
        case TokenError.tokenDidNotLoad:
            print("tokens did not load")
            authModel.unauthenticated()
        case TokenError.tokenDidNotClear:
            print("tokens did not clear")
            authModel.unauthenticated()
        default:
            // HANDLE CONFLICT ERROR
            print("unknown error has occured. figure out a way to pass name of error propagating")
            authModel.unauthenticated()
        }
    }
    
    @MainActor
    func runOnboardingFlow(with authModel: AuthModel, restoringSession: Bool = false, _ operation: @escaping () async throws -> Void) {
        authModel.loading()
        Task {
            do {
                try await operation()
            } catch {
                if restoringSession {
                    self.restoreGoogleInstance(with: authModel)
                } else {
                    self.handleOnboardingError(with: authModel, error: error)
                }
            }
        }
    }
    
    @MainActor
    func transition(with authModel: AuthModel) {
        
        guard let user = authModel.user else {
            print("user is nil within onboarding model, cannot transition to new view")
            return
        }

        if let userIsOnboarded = user.isOnboarded {
            if !userIsOnboarded {
                print("user is not onboarded")
                authModel.notOnboarded()
                return
            } else {
                print("user is onboarded")
            }
        }

        if user.circleID != nil {
            print("user.circleID is not nil")
            authModel.authenticatedInCircle()
            return
        } else {
            print("user.circleID is nil")
            authModel.authenticatedNotInCircle()
            return
        }
    }
    
    func startup(with authModel: AuthModel) async {
        await restoreSession(with: authModel)
    }
    
    func restoreSession(with authModel: AuthModel) async {
        runOnboardingFlow(with: authModel, restoringSession: true) {
            let tokenController = TokenController()
            let refreshToken = try tokenController.loadToken(as: .refresh)
            let tokens = try await self.apiClient.requestNewAccessToken(refreshToken: refreshToken)
            try tokenController.storeTokens(tokens: tokens)
            let accessToken = try tokenController.loadToken(as: .access)
            authModel.user = try await self.apiClient.fetchUser(accessToken: accessToken)
            self.transition(with: authModel)
        }
    }
}
