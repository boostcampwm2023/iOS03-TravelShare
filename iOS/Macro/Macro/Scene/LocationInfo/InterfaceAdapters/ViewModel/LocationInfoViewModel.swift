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
    private var infoType: InfoType = .post
    
    // MARK: - Input
    
    enum Input {
        case changeSelectType(InfoType)
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
            case let .changeSelectType(searchType):
                self?.changeSelectType(type: searchType)
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func changeSelectType(type: InfoType) {
        infoType = type
    }
}
