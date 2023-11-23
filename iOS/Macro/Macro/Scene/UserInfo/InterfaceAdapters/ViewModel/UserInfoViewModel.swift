//
//  UserInfoViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation

class UserInfoViewModel: ViewModelProtocol {
 
    // MARK: - Properties
    
    var posts: [PostFindResponse] = []
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    let postSearcher: SearchUseCase
    
    // MARK: - init
    
    init(postSearcher: SearchUseCase) {
        self.postSearcher = postSearcher
    }
    
    // MARK: - Input
    
    enum Input {
        case searchMockPost
    }
    
    // MARK: - Output
    
    enum Output {
        case appleLoginCompleted
        case updateSearchResult([PostFindResponse])
        case navigateToProfileView(String)
        case navigateToReadView(String)
    }
    
    // MARK: - Methods
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .searchMockPost:
                    self?.searchMockPost()
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func searchMockPost() {
        postSearcher.searchMockPost(json: "tempJson").sink { completion in
            if case let .failure(error) = completion {
            }
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.updateSearchResult(response))
        }.store(in: &cancellables)
    }

}

// MARK: - PostCollectionView Delegate
extension UserInfoViewModel: PostCollectionViewProtocol {
    
    func navigateToProfileView(userId: String) {
        self.outputSubject.send(.navigateToProfileView(userId))
    }
    
    func navigateToReadView(postId: String) {
        self.outputSubject.send(.navigateToReadView(postId))
    }
}
