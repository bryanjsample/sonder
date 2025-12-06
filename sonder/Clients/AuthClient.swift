//
//  AuthManager.swift
//  sonder
//
//  Created by Bryan Sample on 12/3/25.
//

import SonderDTOs
import Foundation

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
        func signInWithGoogle(_ user: UserDTO) async throws -> TokenResponseDTO { // /auth/google/success get change to POST
            return TokenResponseDTO(accessToken: AccessTokenDTO(token: "TOKEN", ownerID: UUID(), expiresAt: Date.now, revoked: false), refreshToken: RefreshTokenDTO(token: "TOKEN", ownerID: UUID(), expiresAt: Date.now, revoked: false))
        }
        
        func validate() {
            
        }
    }
}

