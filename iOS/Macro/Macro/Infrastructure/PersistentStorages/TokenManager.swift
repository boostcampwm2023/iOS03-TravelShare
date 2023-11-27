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
    static func decodeJWTToken(token: String) -> TimeInterval? {
        let tokenComponents = token.components(separatedBy: ".")
        
        guard tokenComponents.count == 3,
              let payloadData = tokenComponents[1].base64Decoded(),
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
              let expiresTimeInterval = payload["exp"] as? TimeInterval else {
            return nil
        }
        
        return expiresTimeInterval
    }
    
    static func isTokenExpired() -> LoginState {
        guard let token = KeyChainManager.load(key: "AccessToken"), let decodeToken = decodeJWTToken(token: token) else {
            return LoginState.loggedOut
        }
        let currentTimeInterval = Date().timeIntervalSince1970
        
        return currentTimeInterval < decodeToken ? LoginState.loggedIn : LoginState.loggedOut
    }
    
    static func refreshToken(cancellables: inout Set<AnyCancellable>) {
        let provider = APIProvider(session: URLSession.shared)
        let refreshTokenUseCase: RefreshTokenUseCaseProtocol = RefreshTokenUseCase(provider: provider)
        
        refreshTokenUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Refresh Token Get Fail : ", error)
                }
            } receiveValue: { refreshTokenResponse in
                KeyChainManager.save(key: KeyChainManager.Keywords.accessToken, token: refreshTokenResponse.accessToken)
            }
            .store(in: &cancellables)
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
