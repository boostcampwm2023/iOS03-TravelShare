//
//  AppleLoginUseCase.swift
//  Macro
//
//  Created by 김경호 on 11/16/23.
//

import Combine
import Foundation

enum ResponseStatus {
    case success
    case failure
}

protocol AppleLoginUseCaseProtocol {
    func execute(requestValue: LoginRequest) -> AnyPublisher<ResponseStatus, HTTPError>
}

struct AppleLoginUseCase: AppleLoginUseCaseProtocol {
    private let repository: LoginRepository
    
    init(repository: LoginRepository) {
        self.repository = repository
    }
    
    func execute(requestValue: LoginRequest) -> AnyPublisher<ResponseStatus, HTTPError> {
        return repository.execute(requestValue: requestValue)
            .eraseToAnyPublisher()
    }
}
