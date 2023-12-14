//
//  AppleLoginUseCase.swift
//  Macro
//
//  Created by 김경호 on 11/16/23.
//

import Combine
import Foundation
import MacroNetwork

protocol AppleLoginUseCaseProtocol {
    func execute(identityToken: String) -> AnyPublisher<LoginResponse, MacroNetwork.NetworkError>
}

struct AppleLoginUseCase: AppleLoginUseCaseProtocol {
    
    // MARK: - Properties
    
    private let repository: LoginRepositoryProtocol
    
    // MARK: - Init
    
    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Methods
    
    func execute(identityToken: String) -> AnyPublisher<LoginResponse, MacroNetwork.NetworkError> {
        return repository.execute(identityToken: identityToken)
    }
}
