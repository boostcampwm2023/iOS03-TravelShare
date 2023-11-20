//
//  DefaultLoginRepository.swift
//  Macro
//
//  Created by 김경호 on 11/15/23.
//

import Combine
import Foundation

protocol LoginRepository {
    func execute(requestValue: LoginRequest) -> AnyPublisher<ResponseStatus, HTTPError>
}
