//
//  UserInfoViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation

final class UserInfoViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    
    var posts: [PostFindResponseHashable] = []
    var userProfile: UserProfile = UserProfile(email: "", name: "", imageUrl: nil, introduce: nil, followersNum: 0, followeesNum: 0, followee: false, follower: false)
    var searchUserEmail = ""
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    let searcher: SearchUseCase
    let followFeature: FollowUseCase
    let patcher: PatchUseCase
    
    // MARK: - Init
    
    init(postSearcher: SearchUseCase, followFeature: FollowUseCase, patcher: PatchUseCase) {
        self.searcher = postSearcher
        self.followFeature = followFeature
        self.patcher = patcher
    }
    
    // MARK: - Input
    
    enum Input {
        case searchUserProfile(email: String)
        case tapFollowButton
        
        // Mock
        case searchMockUserProfile(userId: String)
    }
    
    // MARK: - Output
    
    enum Output {
        case appleLoginCompleted
        case navigateToProfileView(String)
        case navigateToReadView(Int)
        case updateFollowResult(FollowResponse, Bool)
        case updateUserProfile(UserProfile)
        case updateUserPost([PostFindResponseHashable])
        case updatePostLike(LikePostResponse)
        case updateUserFollow(FollowPatchResponse)
    }
    
}

// MARK: - Methods

extension UserInfoViewModel {
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .tapFollowButton:
                    self?.tappedFollowButton()
                case .searchUserProfile:
                    self?.searchUser()
                case let .searchMockUserProfile(userId):
                    self?.searchMockUserProfile(userId: userId)
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func tappedFollowButton() {
        followFeature.followUser(email: searchUserEmail).sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: { [weak self] _ in
            self?.searchUserProfile()
        }.store(in: &cancellables)
    }
    
    private func searchUser() {
        searchUserProfile()
        searchPost()
    }
    
    private func searchUserProfile() {
        searcher.searchUserProfile(query: searchUserEmail).sink { _ in
        } receiveValue: { [weak self] response in
            self?.userProfile = response
            self?.outputSubject.send(.updateUserProfile(response))
        }.store(in: &cancellables)
        
    }
    
    private func searchPost() {
        searcher.searchPost(query: searchUserEmail, postCount: posts.count).sink { _ in
        } receiveValue: { [weak self] response in
            let sortedResponse = response.sorted { $0.postId > $1.postId }
            let sortedResponseHashable = sortedResponse.map { PostFindResponseHashable(postFindResponse: $0) }
            self?.posts = sortedResponseHashable
            self?.outputSubject.send(.updateUserPost(sortedResponseHashable))
        }.store(in: &cancellables)
    }
    
    private func searchMockUserProfile(userId: String) {
        searcher.searchMockUserProfile(query: userId, json: "UserInfoMock").sink { _ in
        } receiveValue: { _ in
            // self?.outputSubject.send(.updateUserProfile(response))
        }.store(in: &cancellables)
    }
}
