//
//  WriteViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Combine
import NMapsMap
import MacroNetwork
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
    private var postPublic: Bool = true
    private var title: String = ""
    private var summary: String = ""
    private var route: Route = Route(coordinates: [])
    var contents: [Content] = []
    private var mappingPins: [NMFMarker?] = []
    
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
        case pinMapping(Coordinate?)
        case selectedMarker(NMFMarker?)
    }
    
    // MARK: - Output

    enum Output {
        case isVisibilityToggle(Bool)
        case outputImageData([Data])
        case postUploadSuccess
        case postUploadFail
        case outputDescriptionString(String)
        case updatePageIndex(Int)
        case updateMap(TravelInfo)
        case updatePin(NMFMarker?)
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
                    self?.mappingPins.append(nil)
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
                case let .pinMapping(coordinate):
                    self?.pinMapping(coordinate: coordinate)
                case let .selectedMarker(marker):
                    self?.selectedMarker(marker)
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
        let imageSaveManager = ImageSaveManager.shared
        
        imageSaveManager.convertImageDatasToImageURLs(imageDatas: imageDatas) { imageURLs in
            imageURLs.enumerated().forEach {
                self.contents[$0].imageURL = $1
            }

            guard let startAt = self.travelInfo.startAt, let endAt = self.travelInfo.endAt else { return }
            guard let recordedLocation = self.travelInfo.recordedLocation else { return }
            let transRecordedLocation = recordedLocation.compactMap { position in
                Coordinate(xPosition: position[1], yPosition: position[0])
            }
            
            let pins: [Pin] = self.travelInfo.recordedPinnedLocations?.compactMap { pin in
                Pin(placeId: pin.placeId ?? "",
                    placeName: pin.placeName ?? "",
                    phoneNumber: pin.phoneNumber == "" ? nil : pin.phoneNumber,
                    category: pin.category ?? "",
                    address: pin.address ?? "",
                    roadAddress: pin.roadAddress == "" ? nil : pin.roadAddress,
                    coordinate: Coordinate(xPosition: pin.coordinate?.longitude ?? 0, yPosition: pin.coordinate?.latitude ?? 0))
            } ?? []
            
            let post = Post(title: self.title,
                            summary: self.summary,
                            route: Route(coordinates: transRecordedLocation),
                            pins: pins,
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
                        self?.outputSubject.send(.postUploadFail)
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
        guard let marker = mappingPins[carouselCurrentIndex] else { return }
        outputSubject.send(.updatePin(marker))
    }
    
    private func pinMapping(coordinate: Coordinate?) {
        guard (0..<contents.count).contains(pageIndex) else { return }
        contents[pageIndex].coordinate = coordinate
    }
    
    private func selectedMarker(_ marker: NMFMarker?) {
        guard (0..<contents.count).contains(pageIndex) else { return }
        mappingPins[carouselCurrentIndex] = marker
    }
}
