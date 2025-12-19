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
    
    @Bindable var authModel: AuthModel
    let apiClient = DefaultAPIClient()
    let tokenController = TokenController()
    
    init(authModel: AuthModel) { self.authModel = authModel }
    
    func handleOnboardingError(_ error: Error) {
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
    func runOnboardingFlow(restoringSession: Bool = false, _ operation: @escaping () async throws -> Void) {
        self.authModel.loading()
        Task {
            do {
                try await operation()
            } catch {
                if restoringSession {
                    self.restoreGoogleInstance()
                } else {
                    self.handleOnboardingError(error)
                }
            }
        }
    }
    
    @MainActor
    func transition() {
        
        guard let user = self.authModel.user else {
            print("user is nil within onboarding model, cannot transition to new view")
            return
        }

        if let userIsOnboarded = user.isOnboarded {
            if !userIsOnboarded {
                print("user is not onboarded")
                self.authModel.notOnboarded()
                return
            } else {
                print("user is onboarded")
            }
        }

        if user.circleID != nil {
            print("user.circleID is not nil")
            self.authModel.authenticatedInCircle()
            return
        } else {
            print("user.circleID is nil")
            self.authModel.authenticatedNotInCircle()
            return
        }
    }
    
    func startup() async {
        await restoreSession()
    }
    
    func restoreSession() async {
        runOnboardingFlow(restoringSession: true) {
            let refreshToken = try self.tokenController.loadToken(as: .refresh)
            let tokens = try await self.apiClient.requestNewAccessToken(refreshToken: refreshToken)
            try self.tokenController.storeTokens(tokens: tokens)
            let accessToken = try self.tokenController.loadToken(as: .access)
            self.authModel.user = try await self.apiClient.fetchUser(accessToken: accessToken)
            guard let circleID = self.authModel.user?.circleID else {
                self.transition()
                return
            }
            self.authModel.circle = try await self.apiClient.fetchCircle(circleID, accessToken: accessToken)
            self.transition()
        }
    }
}
