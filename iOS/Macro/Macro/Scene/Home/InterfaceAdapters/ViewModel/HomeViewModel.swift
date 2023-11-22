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
        case searchPost
        case searchMockPost
    }
    
    // MARK: - Output
    
    enum Output {
        case exchangeCell
        case updateSearchResult([PostFindResponse])
    }
    
    // MARK: - Properties
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let postSearcher: SearchUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(postSearcher: SearchUseCase) {
        self.postSearcher = postSearcher
    }
    
    // MARK: - Methods
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .searchPost:
              self?.searchPost()
            case .searchMockPost:
                self?.searchMockPost()
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func searchPost() {
        postSearcher.searchPost().sink { completion in
            if case let .failure(error) = completion {
               
            }
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.updateSearchResult(response))
        }.store(in: &cancellables)
        
    }
    
    private func searchMockPost() {
        postSearcher.searchMockPost(json: "tempJson").sink { completion in
            if case let .failure(error) = completion {
                print(error)
            }
        } receiveValue: { [weak self] response in
            print(response)
            self?.outputSubject.send(.updateSearchResult(response))
        }.store(in: &cancellables)
        
    }
}
