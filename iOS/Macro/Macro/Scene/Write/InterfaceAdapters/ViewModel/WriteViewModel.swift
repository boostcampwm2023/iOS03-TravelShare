//
//  WriteViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Combine
import Foundation

class WriteViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    var isVisibility: Bool = false
    
    // MARK: - init
    init() {
    }
    
    // MARK: - Input
    
    enum Input {
        case isVisibilityButtonTouched
    }
    
    // MARK: - Output

    enum Output {
        case isVisibilityToggle(Bool)
    }
    
    // MARK: - Methods
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .isVisibilityButtonTouched:
//                    self?.outputSubject.send(.isVisibilityToggle(true))
                    self?.isVisibilityToggle()
                }
            }
            .store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func isVisibilityToggle() {
        isVisibility.toggle()
        outputSubject.send(.isVisibilityToggle(isVisibility))
    }
}
