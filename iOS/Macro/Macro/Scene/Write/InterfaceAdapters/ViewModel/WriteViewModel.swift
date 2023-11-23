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
    var imageDatas: [Data] = [] {
        didSet{
            outputSubject.send(.outputImageData(imageDatas))
        }
    }
    var isVisibility: Bool = false
    
    // MARK: - init
    
    init() {
    }
    
    // MARK: - Input
    
    enum Input {
        case isVisibilityButtonTouched
        case addImageData(imageData: Data)
    }
    
    // MARK: - Output

    enum Output {
        case isVisibilityToggle(Bool)
        case outputImageData([Data])
    }
    
    // MARK: - Methods
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .isVisibilityButtonTouched:
                    self?.isVisibilityToggle()
                case let .addImageData(imageData):
                    self?.imageDatas.append(imageData)
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
