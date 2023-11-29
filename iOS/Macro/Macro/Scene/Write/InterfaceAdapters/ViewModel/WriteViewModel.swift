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
    private let uploadPostUseCase: UploadPostUseCase
    private var imageDatas: [Data] = [] {
        didSet{
            outputSubject.send(.outputImageData(imageDatas))
        }
    }
    private var postPublic: Bool = false
    private var title: String = ""
    private var summary: String = ""
    private var route: Route = Route(coordinates: [])
    private var contents: [Content] = []
    private var pins: [Pin] = []
    private var startAt: String = ""
    private var endAt: String = ""
    
    // MARK: - init
    
    init(uploadImageUseCase: UploadImageUseCases, uploadPostUseCase: UploadPostUseCase) {
        self.uploadImageUseCase = uploadImageUseCase
        self.uploadPostUseCase = uploadPostUseCase
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
        case postUploadSuccess
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
        ImageSaveManager.convertImageDataToImageURL(imageDatas: imageDatas, cancellables: &cancellables) { imageURLs in
            imageURLs.enumerated().forEach {
                self.contents[$0].imageURL = $1
            }
            let post = Post(title: self.title,
                            summary: self.summary,
                            route: Route(coordinates: [
                                Coordinate(xPosition: 120, yPosition: 33.6),
                                Coordinate(xPosition: 123, yPosition: 12.2)
                            ]
                                        ),
                            pins: self.pins,
                            contents: self.contents,
                            postPublic: self.postPublic,
                            startAt: "2023-11-29T13:34:14.391Z",
                            endAt: "2023-11-29T13:34:14.391Z")
            
            guard let token = KeyChainManager.load(key: KeyChainManager.Keywords.accessToken) else { return }
            self.uploadPostUseCase.execute(post: post, token: token)
                .receive(on: DispatchQueue.global())
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.outputSubject.send(.postUploadSuccess)
                    case let .failure(error):
                        debugPrint("Post Upload Fail : ", error)
                    }
                } receiveValue: { postId in
                    debugPrint("Post Upload Success : ", postId)
                }
                .store(in: &self.cancellables)
        }
        
//        convertImageDataToImageURL(imageDatas: imageDatas) {
//            self.imageURLs.enumerated().forEach {
//                self.contents[$0].imageURL = $1
//            }
//            let post = Post(title: self.title,
//                            summary: self.summary,
//                            route: Route(coordinates: [
//                                Coordinate(xPosition: 120, yPosition: 33.6),
//                                Coordinate(xPosition: 123, yPosition: 12.2)
//                            ]
//                                        ),
//                            pins: self.pins,
//                            contents: 
//                                [
//                                Content(imageURL: "https://kr.object.ncloudstorage.com/macro-bucket/static/image/boostcampmacro-beeae45f-3772-427c-ab71-bf85b663b043", description: nil, coordinate: nil)
//                            ],
//                            postPublic: self.postPublic,
//                            startAt: "2023-11-29T13:34:14.391Z",
//                            endAt: "2023-11-29T13:34:14.391Z")
//
//            guard let token = KeyChainManager.load(key: KeyChainManager.Keywords.accessToken) else { return }
//                self.uploadPostUseCase.execute(post: post, token: token)
//                    .receive(on: DispatchQueue.global())
//                    .sink { [weak self] completion in
//                        switch completion {
//                        case .finished:
//                            self?.outputSubject.send(.postUploadSuccess)
//                        case let .failure(error):
//                            debugPrint("Post Upload Fail : ", error)
//                        }
//                    } receiveValue: { postId in
//                        debugPrint("Post Upload Success : ", postId)
//                    }
//                    .store(in: &self.cancellables)
//        }
    }
    
    private func didScroll(index: Int) {
        guard (0..<contents.count).contains(index), contents.count != index else {
            outputSubject.send(.outputDescriptionString(""))
            return
        }
        outputSubject.send(.outputDescriptionString(self.contents[index].description ?? ""))
    }
}
