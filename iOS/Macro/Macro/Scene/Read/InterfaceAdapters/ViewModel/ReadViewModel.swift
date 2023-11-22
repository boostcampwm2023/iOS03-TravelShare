//
//  ReadViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation

class ReadViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // MARK: - init
    init() {
    }
    
    // MARK: - Input
    
    enum Input {
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
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
}
