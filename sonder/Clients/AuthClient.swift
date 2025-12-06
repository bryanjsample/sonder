//
//  AuthManager.swift
//  sonder
//
//  Created by Bryan Sample on 12/3/25.
//

import SonderDTOs
import Foundation
import GoogleSignIn

struct AuthClient {
    struct AuthManager {
        func storeTokens(access: String, refresh: String) -> TokenResponseDTO? {
            return nil
            // save tokens to keychain
        }
        
        func loadTokens() -> String? {
            return " "
        }
        
        func clearTokens() {
            
        }
    }

    struct AuthService {
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
            }
        }
        
        func completeGoogleSignIn(_ user: UserDTO) async throws -> TokenResponseDTO { // /auth/google/success get change to POST
            return TokenResponseDTO(accessToken: AccessTokenDTO(token: "TOKEN", ownerID: UUID(), expiresAt: Date.now, revoked: false), refreshToken: RefreshTokenDTO(token: "TOKEN", ownerID: UUID(), expiresAt: Date.now, revoked: false))
        }
        
        func validate() {
            
        }
    }
}

