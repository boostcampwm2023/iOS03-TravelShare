//
//  WithdrawUseCase.swift
//  Macro
//
//  Created by Byeon jinha on 12/6/23.
//

import Combine
import MacroNetwork

protocol RevokeUseCase {
    func withdraw(identityToken: String, authorizationCode: String) -> AnyPublisher<AppleRevokeResponse, MacroNetwork.NetworkError>
}

struct Revoker: RevokeUseCase {
    
    // MARK: - Properties

    private let provider: Requestable
    
    // MARK: - Init

    init(provider: Requestable) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func withdraw(identityToken: String, authorizationCode: String) -> AnyPublisher<AppleRevokeResponse, MacroNetwork.NetworkError> {
        
        return provider.request(RevokeEndPoint.withdraw(identityToken: identityToken, authorizationCode: authorizationCode))
    }
}
