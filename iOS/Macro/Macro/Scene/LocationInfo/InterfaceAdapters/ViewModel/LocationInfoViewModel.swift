//
//  LocationInfoViewModel.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import Combine

final class LocationInfoViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // MARK: - Input
    
    enum Input {
    }
    
    // MARK: - Output
    
    enum Output {
        
    }
    
    // MARK: - Init
    
}

// MARK: - Methods

extension LocationInfoViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
}
