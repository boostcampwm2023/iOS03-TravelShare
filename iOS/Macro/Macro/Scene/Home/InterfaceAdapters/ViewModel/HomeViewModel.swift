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
    }
    
    // MARK: - Output
    
    enum Output {
        case exchangeCell
        case navigateToProfileView(String)
        case navigateToReadView(Int)
        case updateSearchResult([PostFindResponse])
        case updatePostLike(LikePostResponse)
        case updateUserFollow(FollowPatchResponse)
    }
    
    // MARK: - Properties
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    let postSearcher: SearchUseCase
    let followFeatrue: FollowUseCase
    private var cancellables = Set<AnyCancellable>()
    let patcher: PatchUseCase
    var posts: [PostFindResponse] = []
    
    init(postSearcher: SearchUseCase, followFeature: FollowUseCase, patcher: PatchUseCase) {
        self.postSearcher = postSearcher
        self.followFeatrue = followFeature
        self.patcher = patcher
    }
    
}

// MARK: - Methods

extension HomeViewModel {
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .searchPosts:
              self?.searchPosts()
            case .searchMockPost:
                self?.searchMockPost()
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func searchPosts() {
        postSearcher.fetchHitPost().sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.updateSearchResult(response))
        }.store(in: &cancellables)
    }
    
    private func searchMockPost() {
        postSearcher.searchMockPost(json: "tempJson").sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.updateSearchResult(response))
        }.store(in: &cancellables)
        
    }
    
    private func searchPost(postId: Int) {
        self.outputSubject.send(.navigateToReadView(postId))
    }
    
}
