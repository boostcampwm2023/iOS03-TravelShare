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
    private var postPublic: Bool = false
    private var title: String = ""
    private var contents: [Content] = []
    private var startAt: String = ""
    private var endAt: String = ""
    
    // MARK: - init
    
    init(uploadImageUseCase: UploadImageUseCases) {
        self.uploadImageUseCase = uploadImageUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case isVisibilityButtonTouched
        case addImageData(imageData: Data)
        case writeSubmit
        case didScroll(Int)
        case titleTextUpdate(String)
        case imageDescriptionUpdate(index: Int, description: String)
    }
    
    // MARK: - Output

    enum Output {
        case isVisibilityToggle(Bool)
        case outputImageData([Data])
        case uploadWrite
        case outputDescriptionString(String)
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
                    self?.contents.append(Content(imageURL: "", description: nil, coordinate: nil))
                case .writeSubmit:
                    self?.writeSubmit()
                case let .didScroll(index):
                    self?.didScroll(index: index)
                case let .titleTextUpdate(titleText):
                    self?.title = titleText
                case let .imageDescriptionUpdate(index: index, description: description):
                    self?.contentsDescriptionUpdate(index: index, description: description)
                }
            }
            .store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func isVisibilityToggle() {
        postPublic.toggle()
        outputSubject.send(.isVisibilityToggle(postPublic))
    }
    
    private func contentsDescriptionUpdate(index: Int, description: String) {
        guard (0..<contents.count).contains(index), contents.count != index else { return }
        contents[index].description = description
    }
    
    private func writeSubmit() {
        // TODO: - Image 모두 완료했는지 체크하기
        imageDatas.forEach { imageData in
            uploadImageUseCase.execute(imageData: imageData)
                .receive(on: DispatchQueue.global())
                .sink { completion in
                    if case let .failure(error) = completion {
                        debugPrint("Image Upload Fail : ", error)
                    }
                } receiveValue: { [weak self] imageURLResponse in
                    self?.imageURLs.append(imageURLResponse.url)
                }
                .store(in: &cancellables)
        }
        
        self.imageURLs.forEach {
            self.contents.append(
                Content(imageURL: $0 ?? "",
                        description: nil, // TODO: - 요거 뭐지
                        coordinate: nil) // TODO: - 요거 뭐지
            )
        }
        
        let post = Post(title: self.title,
                        summary: "", // TODO: - 요거 뭐지
                        route: Route(coordinates: []), // TODO: - 요것도 좋아
                        contents: contents,
                        postPublic: self.postPublic,
                        startAt: self.startAt, // TODO: - 요거 뭐지
                        endAt: self.endAt) // TODO: - 요거 뭐지
    }
    
    private func didScroll(index: Int) {
        guard (0..<contents.count).contains(index), contents.count != index else {
            outputSubject.send(.outputDescriptionString(""))
            return
        }
        outputSubject.send(.outputDescriptionString(self.contents[index].description ?? ""))
    }
}
