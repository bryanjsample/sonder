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
    
    func storeAccessToken(with onboardingModel: OnboardingModel, accessToken: AccessTokenDTO) {
        let service = "com.sonder.keys.access"
        let account = accessToken.ownerID.uuidString
        let data = accessToken.token.data(using: .utf8)!
        let addAccessQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                             kSecAttrService as String: service,
                                             kSecAttrAccount as String: account,
                                             kSecValueData as String: data,
                                             kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly]
        
        let accessStatus = SecItemAdd(addAccessQuery as CFDictionary, nil)
        guard accessStatus == errSecSuccess else {
            let message = SecCopyErrorMessageString(accessStatus, nil)
            print("access status = \(message!)")
            return
        }
        
        print("access key stored")
    }
    
    func storeRefreshToken(with onboardingModel: OnboardingModel, refreshToken: RefreshTokenDTO) {
        
        let service = "com.sonder.keys.refresh"
        let account = refreshToken.ownerID.uuidString
        let data = refreshToken.token.data(using: .utf8)!
        let addRefreshQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                             kSecAttrService as String: service,
                                             kSecAttrAccount as String: account,
                                             kSecValueData as String: data,
                                             kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly]
        
        let refreshStatus = SecItemAdd(addRefreshQuery as CFDictionary, nil)
        guard refreshStatus == errSecSuccess else {
            let message = SecCopyErrorMessageString(refreshStatus, nil)
            print("refresh status = \(message!)")
            return
        }
        
        print("refresh key stored")
    }
    
    func storeTokens(with onboardingModel: OnboardingModel, tokens: TokenResponseDTO) {
        clearTokens(with: onboardingModel, storingNewTokens: true)
        storeAccessToken(with: onboardingModel, accessToken: tokens.accessToken)
        storeRefreshToken(with: onboardingModel, refreshToken: tokens.refreshToken)
    }
    
    func loadRefreshToken(with onboardingModel: OnboardingModel) {
        let service = "com.sonder.keys.refresh"
        let getQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: service]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else {
            let message = SecCopyErrorMessageString(status, nil)
            print("refresh load status = \(message!)")
            return
        }
        print("refresh item = \(item!)")
        
        let data = item as? Data
        if let data {
            let str = String(data: data, encoding: .utf8)
            print("refresh key = \(str!)")
        }
    }
    
    func loadAccessToken(with onboardingModel: OnboardingModel) {
        let service = "com.sonder.keys.access"
        let getQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: service]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else {
            let message = SecCopyErrorMessageString(status, nil)
            print("access load status = \(message!)")
            return
        }
        print("access item = \(item!)")

        let data = item as? Data
        if let data {
            let str = String(data: data, encoding: .utf8)
            print("access key = \(str!)")
        }
    }
    
    func loadTokens(with onboardingModel: OnboardingModel) {
        loadAccessToken(with: onboardingModel)
        loadRefreshToken(with: onboardingModel)
        
    }
    
    func clearRefreshTokens(with onboardingModel: OnboardingModel) {
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
    
    func clearAccessTokens(with onboardingModel: OnboardingModel) {
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
    
    
    func clearTokens(with onboardingModel: OnboardingModel, storingNewTokens: Bool = false) {
        clearAccessTokens(with: onboardingModel)
        clearRefreshTokens(with: onboardingModel)
        if !storingNewTokens {
            onboardingModel.unauthenticated()
        }
    }
}
