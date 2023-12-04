//
//  WriteViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Combine
import UIKit.UIImage

final class WriteViewModel: ViewModelProtocol, CarouselViewProtocol {
    
    // MARK: - Properties
    var pageIndex = 0 {
        didSet {
            self.outputSubject.send(.updatePageIndex(pageIndex))
        }
    }
    
    private let travelInfo: TravelInfo
    var items: [UIImage?] = []
    var carouselCurrentIndex: Int = 0
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let uploadImageUseCase: UploadImageUseCases
    private let uploadPostUseCase: UploadPostUseCase
    private var imageDatas: [Data] = [] {
        didSet {
            outputSubject.send(.outputImageData(imageDatas))
        }
    }
    private var postPublic: Bool = false
    private var title: String = ""
    private var summary: String = ""
    private var route: Route = Route(coordinates: [])
    private var contents: [Content] = []
    
    // MARK: - Init
    
    init(uploadImageUseCase: UploadImageUseCases, uploadPostUseCase: UploadPostUseCase, travelInfo: TravelInfo) {
        self.uploadImageUseCase = uploadImageUseCase
        self.uploadPostUseCase = uploadPostUseCase
        self.travelInfo = travelInfo
    }
    
    // MARK: - Input
    
    enum Input {
        case isVisibilityButtonTouched
        case addImageData(imageData: Data)
        case writeSubmit
        case didScroll(Int)
        case titleTextUpdate(String)
        case summaryTextUpdate(String)
        case imageDescriptionUpdate(index: Int, description: String)
        case loadTravel
    }
    
    // MARK: - Output

    enum Output {
        case isVisibilityToggle(Bool)
        case outputImageData([Data])
        case postUploadSuccess
        case outputDescriptionString(String)
        case updatePageIndex(Int)
        case updateMap(TravelInfo)
    }
    
}

// MARK: - Methods

extension WriteViewModel {
    
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
                case let .summaryTextUpdate(summaryText):
                    self?.summary = summaryText
                case .loadTravel:
                    guard let travelInfo = self?.travelInfo else { return }
                    self?.outputSubject.send(.updateMap(travelInfo))
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
            
            guard let startAt = self.travelInfo.startAt, let endAt = self.travelInfo.endAt else { return }
            guard let recordedLocation = self.travelInfo.recordedLocation else { return }
            let transRecordedLocation = recordedLocation.compactMap { position in
                Coordinate(xPosition: position[1], yPosition: position[0])
            }
            let post = Post(title: self.title,
                            summary: self.summary,
                            route: Route(coordinates: transRecordedLocation),
                            // TODO: pin CoreData 작업 후 수정해야합니다 :)
                            pins: [],
                            contents: self.contents,
                            postPublic: self.postPublic,
                            startAt: startAt,
                            endAt: endAt)
            
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
    }
    
    private func didScroll(index: Int) {
        guard (0..<contents.count).contains(index), contents.count != index else {
            outputSubject.send(.outputDescriptionString(""))
            return
        }
        outputSubject.send(.outputDescriptionString(self.contents[index].description ?? ""))
    }
}
