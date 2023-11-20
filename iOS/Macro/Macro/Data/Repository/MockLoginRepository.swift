//
//  MockLoginRepository.swift
//  Macro
//
//  Created by 김경호 on 11/19/23.
//

import Combine
import Foundation

class MockLoginRepository: LoginRepository {
    private let mockResponse: ResponseStatus = ResponseStatus.success
    
    func execute(requestValue: LoginRequest) -> AnyPublisher<ResponseStatus, HTTPError> {
        return Just(mockResponse)
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
}
