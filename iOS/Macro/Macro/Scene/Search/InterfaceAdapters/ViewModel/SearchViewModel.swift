//
//  SearchViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Combine
import Foundation
import MacroNetwork

final class SearchViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let searcher: SearchUseCase
    private (set) var searchType: SearchType = .post
    private (set) var posts: [PostFindResponse] = []
    private let patcher: PatchUseCase
    
    // MARK: - Init
    
    init(searcher: SearchUseCase, patcher: PatchUseCase) {
        self.searcher = searcher
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
                    guard let self = self else { return }
                    switch self.searchType {
                    case .account: self.searchAccount(text: text)
                    case .post: self.searchPost(text: text)
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
        searcher.searchAccountWord(query: text).sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: { [weak self] response in
            print(response)
        }.store(in: &cancellables)

    }
    
    private func searchPost(text: String) {
        searcher.searchPostTitle(query: text)
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
    
}

// MARK: - Mock Methods

extension SearchViewModel {
    private func searchMockPost(text: String) {
        searcher.searchMockPost(query: text, json: "tempJson").sink { completion in
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
