//
//  TokenClient.swift
//  sonder
//
//  Created by Bryan Sample on 12/10/25.
//

import Security
import SonderDTOs
import Foundation

final class TokenClient {
    
    init () { }
    
    func storeAccessToken(accessToken: AccessTokenDTO) {
        let service = "com.sonder.keys.access"
//        let account = accessToken.ownerID.uuidString
        guard let data = accessToken.token.data(using: .utf8) else {
            print("access store data is nil")
            return
        }
        let addAccessQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                             kSecAttrService as String: service,
//                                             kSecAttrAccount as String: account,
                                             kSecValueData as String: data,
                                             kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly]
        
        let accessStatus = SecItemAdd(addAccessQuery as CFDictionary, nil)
        guard accessStatus == errSecSuccess else {
            if let message = SecCopyErrorMessageString(accessStatus, nil) {
                print("access store status = \(message)")
            }
            return
        }
        
        print("access key stored")
    }
    
    func storeRefreshToken(refreshToken: RefreshTokenDTO) {
        
        let service = "com.sonder.keys.refresh"
//        let account = refreshToken.ownerID.uuidString
        guard let data = refreshToken.token.data(using: .utf8) else {
            print("refresh store data is nil")
            return
        }
        let addRefreshQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                             kSecAttrService as String: service,
//                                             kSecAttrAccount as String: account,
                                             kSecValueData as String: data,
                                             kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly]
        
        let refreshStatus = SecItemAdd(addRefreshQuery as CFDictionary, nil)
        guard refreshStatus == errSecSuccess else {
            if let message = SecCopyErrorMessageString(refreshStatus, nil) {
                print("refresh store status = \(message)")
            }
            return
        }
        
        print("refresh key stored")
    }
    
    func storeTokens(tokens: TokenResponseDTO) {
        clearTokens()
        storeAccessToken(accessToken: tokens.accessToken)
        storeRefreshToken(refreshToken: tokens.refreshToken)
    }
    
    func loadRefreshToken() -> TokenStringDTO? {
        let service = "com.sonder.keys.refresh"
        let getQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: service,
                                       kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else {
            if let message = SecCopyErrorMessageString(status, nil) {
                print("refresh load status = \(message)")
            }
            return nil
        }
        
        guard let data = item as? Data else {
            print("refresh load data is nil")
            return nil
        }
        guard let token = String(data: data, encoding: .utf8) else {
            print("refresh load key is nil")
            return nil
        }
        print("refresh load key = \(token)")
        return TokenStringDTO(token)
        

    }
    
    func loadAccessToken() -> TokenStringDTO?? {
        let service = "com.sonder.keys.access"
        let getQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: service,
                                       kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else {
            if let message = SecCopyErrorMessageString(status, nil) {
                print("access load status = \(message)")
            }
            return nil
        }
        if let item {
            print("access load item = \(item)")
        } else {
            print("access load item is nil")
        }
        guard let data = item as? Data else {
            print("access load data is nil")
            return nil
        }
        guard let token = String(data: data, encoding: .utf8) else {
            print("access load key is nil")
            return nil
        }
        print("access load key = \(token)")
        return TokenStringDTO(token)
    }
    
    func loadTokens() -> (TokenStringDTO?, TokenStringDTO?) {
        let accessToken = loadAccessToken()
        let refreshToken = loadRefreshToken()
        return (accessToken ?? nil, refreshToken ?? nil)
    }
    
    func clearRefreshTokens() {
        let service = "com.sonder.keys.refresh"
        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrService as String: service]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        guard status == errSecSuccess else {
            let message = SecCopyErrorMessageString(status, nil)
            print("refresh delete status = \(message!)")
            return
        }
        
        print("refresh key deleted")
    }
    
    func clearAccessTokens() {
        let service = "com.sonder.keys.access"
        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrService as String: service]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        guard status == errSecSuccess else {
            let message = SecCopyErrorMessageString(status, nil)
            print("access delete status = \(message!)")
            return
        }
        
        print("access key deleted")
    }
    
    
    func clearTokens() {
        clearAccessTokens()
        clearRefreshTokens()
    }
}
