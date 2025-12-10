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
    case loading, notOnboarded, authenticatedNotInCircle, authenticatedInCircle, unauthenticated, error(String)
}

@Observable
final class AuthViewModel {

    var status: AuthStatus = .loading

    init() { }

    func startup() {
        restoreSession()
    }

    func restoreSession() {
        
        if let _ = self.loadTokens() {
            // Optional: validate/refresh with backend
//            do {
//                try await authService.validate(tokens: tokens)
            status = .unauthenticated
//                return
//            } catch {
//                // Tokens invalid/expired
//            }
        } else {
            restoreGoogleInstance()
        }
    }
    
    func restoreGoogleInstance() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let info = user {
                print("Session restored user = \(info.profile!.email)")
                self.status = .unauthenticated
                return
            }
            if let err = error {
                print(err)
                self.status = .unauthenticated
                return
            }
        }
    }
    
    func completeGoogleOAuth(presentingVC: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
                // Handle the error without throwing
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            
            guard let result = signInResult else {
                print("Google Sign-In: No result returned")
                return
            }
            
            print("Google Sign-In succeeded for user: \(result.user.profile?.email ?? "<unknown>")")
            
            self.signIn()
        }
    }
    
    func storeTokens(access: String, refresh: String) -> TokenResponseDTO? {
        return nil
    }
    
    func loadTokens() -> TokenResponseDTO? {
        return nil
    }
    
    func clearTokens() {
        
    }
    
    func signIn() {
        status = .notOnboarded
    }
    
    func createUser() {
        status = .authenticatedNotInCircle
    }
    
    func createCircle() {
        status = .authenticatedInCircle
    }

    func signOut() {
        self.clearTokens()
        GIDSignIn.sharedInstance.signOut()
        status = .unauthenticated
    }
}

