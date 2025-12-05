//
//  AuthViewModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/3/25.
//

import SwiftUI
import SonderDTOs
import GoogleSignIn

enum AuthState: Equatable {
    case loading
    case authenticatedInCircle
    case authenticatedNotInCircle
    case unauthenticated
    case error(String)
}

final class AuthViewModel {
    @State var state: AuthState = .unauthenticated

    private let authManager: AuthClient.AuthManager
    private let authService: AuthClient.AuthService

    init(authManager: AuthClient.AuthManager = AuthClient.AuthManager(),
         authService: AuthClient.AuthService = AuthClient.AuthService()) {
        self.authManager = authManager
        self.authService = authService
    }

    func startup() {
        restoreSession()
    }

    func restoreSession() {
        if let tokens = authManager.loadTokens() {
            // Optional: validate/refresh with backend
//            do {
//                try await authService.validate(tokens: tokens)
                state = .authenticatedInCircle
//                return
//            } catch {
//                // Tokens invalid/expired
//            }
        }

        state = .unauthenticated
    }

    func completeGoogleSignIn(userDTO: UserDTO, idToken: String?) async {
        do {
            // Exchange Google credentials with your backend for app tokens
            let result = try await authService.signInWithGoogle(userDTO)
            _ = authManager.storeTokens(access: result.accessToken.token, refresh: result.refreshToken.token)
            state = .authenticatedInCircle
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func signOut() {
        authManager.clearTokens()
        GIDSignIn.sharedInstance.signOut()
        state = .unauthenticated
    }
}

