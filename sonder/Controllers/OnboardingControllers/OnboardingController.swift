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
    
    func handleOnboardingError(with onboardingModel: OnboardingModel, error: Error) {
        switch error {
        case APIError.badRequest:
            print("badRequest error thrown in the api client")
            onboardingModel.notOnboarded()
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
            // HANDLE CONFLICT ERROR
            print("unknown error has occured. figure out a way to pass name of error propagating")
            onboardingModel.unauthenticated()
        }
    }
    
    @MainActor
    func runOnboardingFlow(with onboardingModel: OnboardingModel, restoringSession: Bool = false, _ operation: @escaping () async throws -> Void) {
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
    func transition(with onboardingModel: OnboardingModel) {
        
        guard let user = onboardingModel.user else {
            print("user is nil within onboarding model, cannot transition to new view")
            return
        }

        if let userIsOnboarded = user.isOnboarded {
            if !userIsOnboarded {
                print("user is not onboarded")
                onboardingModel.notOnboarded()
                return
            } else {
                print("user is onboarded")
            }
        }

        if user.circleID != nil {
            print("user.circleID is not nil")
            onboardingModel.authenticatedInCircle()
            return
        } else {
            print("user.circleID is nil")
            onboardingModel.authenticatedNotInCircle()
            return
        }
    }
    
    func startup(with onboardingModel: OnboardingModel) async {
        await restoreSession(with: onboardingModel)
    }
    
    func restoreSession(with onboardingModel: OnboardingModel) async {
        runOnboardingFlow(with: onboardingModel, restoringSession: true) {
            let tokenController = TokenController()
            let refreshToken = try tokenController.loadToken(as: .refresh)
            let tokens = try await self.apiClient.requestNewAccessToken(refreshToken: refreshToken)
            try tokenController.storeTokens(tokens: tokens)
            let accessToken = try tokenController.loadToken(as: .access)
            onboardingModel.user = try await self.apiClient.fetchUser(accessToken: accessToken)
            self.transition(with: onboardingModel)
        }
    }
}
