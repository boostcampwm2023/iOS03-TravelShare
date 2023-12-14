//
//  File.swift
//  Macro
//
//  Created by 김경호 on 11/15/23.
//

import Foundation

struct KeyChainManager {
    /// 키체인 데이터 저장 함수
    static func save(key: String, token: String) {
        if let data = token.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecDuplicateItem {
                let updateQuery: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: key
                ]
                
                let attributes: [String: Any] = [
                    kSecValueData as String: data
                ]

                SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
            }
        }
    }
    
    /// 키체인 데이터 삭제 함수
    static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }
    
    /// 키체인에서 데이터 검색 함수
    static func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            if let token = String(data: data, encoding: .utf8) {
                return token
            }
        }
        
        return nil
    }
}

extension KeyChainManager {
    enum Keywords {
        static let accessToken = "AccessToken"
        static let refreshToken = "RefreshToken"
    }
}
