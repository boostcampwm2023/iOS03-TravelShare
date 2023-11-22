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
    private let postSearcher: SearchUseCase
    private var searchType: SearchType = .post
    private (set) var searchedPostResult: [PostFindResponse] = []
    
    // MARK: - init
    init(postSearcher: SearchUseCase) {
        self.postSearcher = postSearcher
    }
    
    // MARK: - Input
    
    enum Input {
        case changeSelectType(SearchType)
        case search(String)
    }
    
    // MARK: - Output
    
    enum Output {
        case updateSearchResult([PostFindResponse])
    }
    
    // MARK: - Methods
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .changeSelectType(searchType):
                    self?.changeSelectType(type: searchType)
                case let .search(text):
                    switch self?.searchType {
                    case .account: self?.searchAccount(text: text)
                    case .post: self?.searchMockPost(text: text)
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
        postSearcher.searchPost(query: text)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] response in
                self?.searchedPostResult = response
                let defaultValue = [PostFindResponse]()
                self?.outputSubject.send(.updateSearchResult(self?.searchedPostResult ?? defaultValue ))
                
            }.store(in: &cancellables)
    }
    
    private func searchMockPost(text: String) {
        postSearcher.searchMockPost(query: text, json: "tempJson").sink { completion in
            if case let .failure(error) = completion {
                print(error)
            }
        } receiveValue: { [weak self] response in
            self?.searchedPostResult = response
            self?.searchedPostResult.removeAll { post in
                !post.title.contains(text)
            }
            let defaultValue = [PostFindResponse]()
            self?.outputSubject.send(.updateSearchResult(self?.searchedPostResult ?? defaultValue ))
        }.store(in: &cancellables)
    }
}
