//
//  SearchViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Combine
import Foundation
import MacroNetwork

final class SearchViewModel: ViewModelProtocol, PostCollectionViewProtocol {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let postSearcher: SearchUseCase
    private var searchType: SearchType = .post
    var posts: [PostFindResponse] = []
    var patcher: PatchUseCase
    
    // MARK: - Init
    
    init(postSearcher: SearchUseCase, patcher: PatchUseCase) {
        self.postSearcher = postSearcher
        self.patcher = patcher
    }
    
    // MARK: - Input
    
    enum Input {
        case changeSelectType(SearchType)
        case search(String)
    }
    
    // MARK: - Output
    
    enum Output {
        case updateSearchResult([PostFindResponse])
        case navigateToProfileView(String)
        case navigateToReadView(Int)
        case updatePostLike(LikePostResponse)
        case updateUserFollow(FollowPatchResponse)
    }
    
}

// MARK: - Methods

extension SearchViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .changeSelectType(searchType):
                    self?.changeSelectType(type: searchType)
                case let .search(text):
                    switch self?.searchType {
                    case .account: self?.searchAccount(text: text)
                    case .post: self?.searchPost(text: text)
                    case .none: break
                    }
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func changeSelectType(type: SearchType) {
        searchType = type
    }
    
    private func searchAccount(text: String) {
        
    }
    
    private func searchPost(text: String) {
        postSearcher.searchPostTitle(query: text)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] response in
                self?.posts = response
                let defaultValue = [PostFindResponse]()
                self?.outputSubject.send(.updateSearchResult(self?.posts ?? defaultValue))
            }.store(in: &cancellables)
    }
    
    func navigateToProfileView(email: String) {
        outputSubject.send(.navigateToProfileView(email))
    }
    
    func navigateToReadView(postId: Int) {
        outputSubject.send(.navigateToReadView(postId))
    }
    
    func touchLike(postId: Int) {
        patcher.patchPostLike(postId: postId).sink { _ in
        } receiveValue: { [weak self] likePostResponse in
            self?.outputSubject.send(.updatePostLike(likePostResponse))
        }.store(in: &cancellables)
    }
  
    func touchFollow(email: String) {
        patcher.patchFollow(email: email).sink { _ in
        } receiveValue: { [weak self] followPatchResponse in
            self?.outputSubject.send(.updateUserFollow(followPatchResponse))
        }
    }
    
}

// MARK: - Mock Methods

extension SearchViewModel {
    private func searchMockPost(text: String) {
        postSearcher.searchMockPost(query: text, json: "tempJson").sink { completion in
            if case let .failure(error) = completion {
                print(error)
            }
        } receiveValue: { [weak self] response in
            self?.posts = response
            self?.posts.removeAll { post in
                !post.title.contains(text)
            }
            let defaultValue = [PostFindResponse]()
            self?.outputSubject.send(.updateSearchResult(self?.posts ?? defaultValue ))
        }.store(in: &cancellables)
    }
}
