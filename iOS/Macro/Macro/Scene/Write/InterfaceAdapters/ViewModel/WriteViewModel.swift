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
    private let uploadImageUseCase: UploadImageUseCases
    private var imageDatas: [Data] = [] {
        didSet{
            outputSubject.send(.outputImageData(imageDatas))
        }
    }
    private var imageURLs: [String?] = []
    private var isVisibility: Bool = false
    
    // MARK: - init
    
    init(uploadImageUseCase: UploadImageUseCases) {
        self.uploadImageUseCase = uploadImageUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case isVisibilityButtonTouched
        case addImageData(imageData: Data)
        case writeSubmit
    }
    
    // MARK: - Output

    enum Output {
        case isVisibilityToggle(Bool)
        case outputImageData([Data])
        case uploadWrite
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
                case .writeSubmit:
                    self?.writeSubmit()
                }
            }
            .store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func isVisibilityToggle() {
        isVisibility.toggle()
        outputSubject.send(.isVisibilityToggle(isVisibility))
    }
    
    private func writeSubmit() {
        imageDatas.forEach { imageData in
            uploadImageUseCase.execute(imageData: imageData)
                .receive(on: DispatchQueue.global())
                .sink { [weak self] completion in
                    if case let .failure(error) = completion {
                    }
                } receiveValue: { [weak self] imageURLResponse in
                    self?.imageURLs.append(imageURLResponse.url)
                }
                .store(in: &cancellables)
        }
    }
}
