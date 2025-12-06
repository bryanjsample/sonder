//
//  AuthViewModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/3/25.
//

import SwiftUI
import SonderDTOs
import GoogleSignIn

enum AuthStatus: Equatable {
    case loading
    case authenticatedInCircle
    case authenticatedNotInCircle
    case unauthenticated
    case error(String)
}

@Observable
final class AuthViewModel {

    private let authManager: AuthClient.AuthManager
    private let authService: AuthClient.AuthService
    var status: AuthStatus = .loading

    init(authManager: AuthClient.AuthManager = AuthClient.AuthManager(),
         authService: AuthClient.AuthService = AuthClient.AuthService()) {
        self.authManager = authManager
        self.authService = authService
    }

    func startup() {
        restoreSession()
    }

    func restoreSession() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let info = user {
                print("Session restored user = \(info.profile!.email)")
                self.status = .authenticatedInCircle
                return
            }
            if let err = error {
                print(err)
                self.status = .unauthenticated
                return
            }
        }
        
        if let _ = authManager.loadTokens() {
            // Optional: validate/refresh with backend
//            do {
//                try await authService.validate(tokens: tokens)
            status = .authenticatedInCircle
//                return
//            } catch {
//                // Tokens invalid/expired
//            }
        } else {
            status = .unauthenticated
        }
    }

    func completeGoogleSignIn(userDTO: UserDTO, idToken: String?) async {
        do {
            // Exchange Google credentials with your backend for app tokens
            let result = try await authService.signInWithGoogle(userDTO)
            _ = authManager.storeTokens(access: result.accessToken.token, refresh: result.refreshToken.token)
            status = .authenticatedInCircle
        } catch {
            status = .error(error.localizedDescription)
        }
    }

    func signOut() {
        authManager.clearTokens()
        GIDSignIn.sharedInstance.signOut()
        status = .unauthenticated
    }
}

