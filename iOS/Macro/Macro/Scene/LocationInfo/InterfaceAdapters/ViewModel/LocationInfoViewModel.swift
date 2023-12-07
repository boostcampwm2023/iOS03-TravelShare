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
    private let locationDetail: LocationDetail
    private (set) var posts: [PostFindResponse] = []
    private let searcher: SearchUseCase
    private (set) var relatedLocation: [RelatedLocation] = []
    
    // MARK: - Input
    
    enum Input {
        case changeSelectType(InfoType)
        case viewDidLoad
    }
    
    // MARK: - Output
    
    enum Output {
        case changeTextLabel(LocationDetail?)
        case sendRelatedPost([PostFindResponse])
        case sendRelatedLocation
    }
    
    // MARK: - Init
    init(locationDetail: LocationDetail, searcher: SearchUseCase) {
        self.locationDetail = locationDetail
        self.searcher = searcher
    }
}

// MARK: - Methods

extension LocationInfoViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case let .changeSelectType(searchType):
                self?.changeSelectType(type: searchType)
            case .viewDidLoad:
                self?.outputSubject.send(.changeTextLabel(self?.locationDetail))
                self?.getRelatedPost()
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func changeSelectType(type: InfoType) {
        infoType = type
        switch infoType {
        case .post: getRelatedPost()
        case .location: getRelatedLocation()
        }
    }
    private func getRelatedPost() {
        var placeId = locationDetail.id
        // TODO: 임시로 불러온 값을 확인할 수 있게 지정했음.
        placeId = "7963969"
        searcher.searchRelatedPost(query: placeId, postCount: 0).sink { _ in
        } receiveValue: { [weak self] response in
            self?.posts = response
            self?.outputSubject.send(.sendRelatedPost(response))
        }.store(in: &cancellables)
    }
    
    private func getRelatedLocation() {
        var placeId = locationDetail.id
        // TODO: 임시로 불러온 값을 확인할 수 있게 지정했음.
        placeId = "7963969"
        searcher.searchRelatedLocation(query: placeId).sink { _ in
        } receiveValue: { [weak self] response in
            self?.relatedLocation = response
            self?.outputSubject.send(.sendRelatedLocation)
        }.store(in: &cancellables)
    }
    
}
