//
//  TokenController.swift
//  sonder
//
//  Created by Bryan Sample on 12/10/25.
//

import Security
import SonderDTOs
import Foundation

final class TokenController {
    
    init () { }
    
    func storeToken(_ token: String, as tokenType: TokenType) throws {
        guard let data = token.data(using: .utf8) else {
            throw TokenError.dataEncodingError
        }
        
        let storeQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                         kSecAttrService as String: tokenType.service,
                                         kSecValueData as String: data,
                                         kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly]
        
        let status = SecItemAdd(storeQuery as CFDictionary, nil)
        
        // switch status for each possible status code
        
        guard status == errSecSuccess else {
            throw TokenError.tokenDidNotStore
        }
        
        print("\(tokenType.description) token stored successfully")
    }
    
    func storeTokens(tokens: TokenResponseDTO) throws {
        try clearTokens()
        try storeToken(tokens.accessToken.token, as: .access)
        try storeToken(tokens.refreshToken.token, as: .refresh)
    }
    
    func loadToken(as tokenType: TokenType) throws -> TokenStringDTO {
        let loadQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrService as String: tokenType.service,
                                        kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(loadQuery as CFDictionary, &item)
        
        // switch status for each possible status code
        
        guard status == errSecSuccess else {
            throw TokenError.tokenDidNotLoad
        }
        
        guard let data = item as? Data else {
            throw TokenError.dataCastingError
        }
        
        guard let token = String(data: data, encoding: .utf8) else {
            throw TokenError.dataDecodingError
        }
    
        print("\(tokenType.description) token loaded successfully")
        return TokenStringDTO(token)
    }
    

    func loadTokens() throws -> (TokenStringDTO, TokenStringDTO) {
        let accessToken = try loadToken(as: .access)
        let refreshToken = try loadToken(as: .refresh)
        return (accessToken, refreshToken)
    }
    
    func clearToken(as tokenType: TokenType) throws {
        let clearQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                         kSecAttrService as String: tokenType.service]
        
        print("clearQuery = \(clearQuery)")
        
        let status = SecItemDelete(clearQuery as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("token status = \(status.words)")
            throw TokenError.tokenDidNotClear
        }
        
        if status == errSecItemNotFound {
            print("\(tokenType.description) token not found")
            return
        }
        
        print("\(tokenType.description) key deleted")
    }
    
    func clearTokens() throws {
        try clearToken(as: .access)
        try clearToken(as: .refresh)
    }
}

enum TokenType {
    case access, refresh
    
    var service: String {
        switch self {
        case .access:
            return "com.sonder.keys.access"
        case .refresh:
            return "com.sonder.keys.refresh"
        }
    }
    
    var description: String {
        switch self {
        case .access:
            return "access"
        case .refresh:
            return "refresh"
        }
    }
}
