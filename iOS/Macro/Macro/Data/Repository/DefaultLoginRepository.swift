//
//  DefaultLoginRepository.swift
//  Macro
//
//  Created by 김경호 on 11/15/23.
//

import Combine
import Foundation
import MacroNetwork

protocol LoginRepositoryProtocol {
    func execute(identityToken: String) -> AnyPublisher<LoginResponse, MacroNetwork.NetworkError>
}

class LoginRepository: LoginRepositoryProtocol {
    
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    
    init(provider: Requestable) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func execute(identityToken: String) -> AnyPublisher<LoginResponse, MacroNetwork.NetworkError> {
        return provider.request(LoginEndPoint.login(identityToken: identityToken))
    }
}
