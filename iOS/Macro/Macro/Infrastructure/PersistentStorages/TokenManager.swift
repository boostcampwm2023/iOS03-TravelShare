//
//  TokenManager.swift
//  Macro
//
//  Created by 김경호 on 11/21/23.
//

import Combine
import Foundation
import MacroNetwork

struct TokenManager {
    static func decodeJWTToken(token: String) -> JWTToken? {
        let tokenComponents = token.components(separatedBy: ".")
        
        guard tokenComponents.count == 3,
              let payloadData = tokenComponents[1].base64Decoded(),
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            return nil
        }
        
        return JWTToken(iat: payload["iat"] as? TimeInterval, exp: payload["exp"] as? TimeInterval, role: payload["role"] as? String, emial: payload["email"] as? String)
    }
    
    static func isTokenExpired() -> LoginState {
        guard let token = KeyChainManager.load(key: KeyChainManager.Keywords.accessToken), let tokenExp = decodeJWTToken(token: token)?.exp else {
            return LoginState.loggedOut
        }
        let currentTimeInterval = Date().timeIntervalSince1970
        
        return currentTimeInterval < tokenExp ? LoginState.enter : LoginState.loggedOut
    }
    
    static func refreshToken(cancellables: inout Set<AnyCancellable>) -> Bool {
        let provider = APIProvider(session: URLSession.shared)
        let refreshTokenUseCase: RefreshTokenUseCaseProtocol = RefreshTokenUseCase(provider: provider)
        var flag = true
        refreshTokenUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Refresh Token Get Fail : ", error)
                    flag = false
                }
            } receiveValue: { refreshTokenResponse in
                KeyChainManager.save(key: KeyChainManager.Keywords.accessToken, token: refreshTokenResponse.accessToken)
            }
            .store(in: &cancellables)
        return flag
    }
    
    static func extractEmailFromJWTToken() -> String? {
        guard let token = KeyChainManager.load(key: KeyChainManager.Keywords.accessToken), let email = decodeJWTToken(token: token)?.emial else {
            return nil
        }
        return email
    }
    
    struct JWTToken {
        let iat: TimeInterval?
        let exp: TimeInterval?
        let role: String?
        let emial: String?
    }
}

struct MyClaims: Decodable {
    var sub: String
    var exp: TimeInterval
}

// Base64 디코드를 위한 extension
extension String {
    func base64Decoded() -> Data? {
        let padding = String(repeating: "=", count: (4 - count % 4) % 4)
        guard let data = Data(base64Encoded: replacingOccurrences(of: "-", with: "+")
                                                .replacingOccurrences(of: "_", with: "/") + padding) else {
            return nil
        }
        return data
    }
}
