//
//  HomeViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import Combine
import Foundation

final class HomeViewModel: ViewModelProtocol {
    
    // MARK: - Input
    
    enum Input {
        case searchPosts
        case searchMockPost
        case searchUser(String)
        case searchPost(String)
    }
    
    // MARK: - Output
    
    enum Output {
        case exchangeCell
        case navigateToProfileView(String)
        case navigateToReadView(String)
        case updateSearchResult([PostResponse])
    }
    
    // MARK: - Properties
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let postSearcher: PostSearchUseCase
    private var cancellables = Set<AnyCancellable>()
    var posts: [PostResponse] = []
    
    init(postSearcher: PostSearchUseCase) {
        self.postSearcher = postSearcher
    }
    
    // MARK: - Methods
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .searchPosts:
              self?.searchPosts()
            case .searchMockPost:
                self?.searchMockPost()
            case let .searchUser(userId):
                self?.searchUser(id: userId)
            case let .searchPost(postId):
                self?.searchPost(postId: postId)
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func searchPosts() {
        postSearcher.searchPost().sink { completion in
            if case let .failure(error) = completion {
               
            }
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.updateSearchResult(response))
        }.store(in: &cancellables)
        
    }
    
    private func searchMockPost() {
        postSearcher.searchMockPost().sink { completion in
            if case let .failure(error) = completion {
            }
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.updateSearchResult(response))
        }.store(in: &cancellables)
        
    }
    
    private func searchUser(id: String) {
        self.outputSubject.send(.navigateToProfileView(id))
    }
    
    private func searchPost(postId: String) {
        self.outputSubject.send(.navigateToReadView(postId))
    }
}
