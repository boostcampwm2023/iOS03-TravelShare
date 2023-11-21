//
//  UserInfoViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation

class UserInfoViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // MARK: - init
    init() {
    }
    
    // MARK: - Input
    
    enum Input {
        case temp
    }
    
    // MARK: - Output

    enum Output {
        case appleLoginCompleted
    }
    
    // MARK: - Methods
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .temp:
                    self?.temp()
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
    func temp() {
        
    }
}
