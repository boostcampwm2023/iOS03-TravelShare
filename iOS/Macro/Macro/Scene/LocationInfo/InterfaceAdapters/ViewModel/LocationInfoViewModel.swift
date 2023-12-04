//
//  LocationInfoViewModel.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import Combine

final class LocationInfoViewModel: ViewModelProtocol, PostCollectionViewProtocol {
        
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var infoType: InfoType = .post
    private let locationDetail: LocationDetail
    var posts: [PostFindResponse] = []
    
    // MARK: - Input
    
    enum Input {
        case changeSelectType(InfoType)
        case viewDidLoad
    }
    
    // MARK: - Output
    
    enum Output {
        case changeTextLabel(LocationDetail?)
    }
    
    // MARK: - Init
    init(locationDetail: LocationDetail) {
        self.locationDetail = locationDetail
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
                
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func changeSelectType(type: InfoType) {
        infoType = type
    }
    
    func navigateToProfileView(email: String) {
        //
    }
    
    func navigateToReadView(postId: Int) {
        //
    }
    
    func touchLike(postId: Int) {
        //
    }
    
    func touchFollow(email: String) {
        //
    }
}
