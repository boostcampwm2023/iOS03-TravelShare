//
//  RefreshTokenUseCase.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Combine
import Foundation
import MacroNetwork

protocol RefreshTokenUseCaseProtocol {
    func execute() -> AnyPublisher<RefreshTokenResponse, MacroNetwork.NetworkError>
}

struct RefreshTokenUseCase: RefreshTokenUseCaseProtocol {
    
    private let provider: Requestable
    
    init(provider: Requestable) {
        self.provider = provider
    }
    
    func execute() -> AnyPublisher<RefreshTokenResponse, MacroNetwork.NetworkError> {
        let token = KeyChainManager.load(key: KeyChainManager.Keywords.accessToken) ?? ""
        return provider.request(RefreshTokenEndPoint.refreshToken(token))
    }
}
