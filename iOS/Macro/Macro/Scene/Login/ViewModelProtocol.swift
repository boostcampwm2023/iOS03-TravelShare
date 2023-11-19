//
//  ViewModelProtocol.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Combine
import Foundation

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
