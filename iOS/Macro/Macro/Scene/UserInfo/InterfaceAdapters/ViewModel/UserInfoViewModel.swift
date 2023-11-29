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
    
    var posts: [PostFindResponse] = []
    var userProfile: UserProfile = UserProfile(email: "", name: "", imageUrl: nil, introduce: nil, followersNum: 0, followeesNum: 0)
    var searchUserEmail = ""
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    let searcher: SearchUseCase
    let followFeature: FollowUseCase
    
    // MARK: - init
    
    init(postSearcher: SearchUseCase, followFeature: FollowUseCase) {
        self.searcher = postSearcher
        self.followFeature = followFeature
    }
    
    // MARK: - Input
    
    enum Input {
        case searchUserProfile(email: String)
        case tapFollowButton(userId: String)
        
        // Mock
        case searchMockUserProfile(userId: String)
    }
    
    // MARK: - Output
    
    enum Output {
        case appleLoginCompleted
        case navigateToProfileView(String)
        case navigateToReadView(Int)
        case updateFollowResult(FollowResponse)
        case updateUserProfile(ProfileGetResponse)
        case updateUserPost([PostFindResponse])
    }
    
    // MARK: - Methods
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .tapFollowButton(userId):
                    self?.tappedFollowButton(followUserId: userId)
                case .searchUserProfile:
                    self?.searchUserProfile()
                case let .searchMockUserProfile(userId):
                    self?.searchMockUserProfile(userId: userId)
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func tappedFollowButton(followUserId: String) {
        // TODO: - 통신코드 목파일 수정
        followFeature.mockFollowUser(userId: "asdf", followUserId: followUserId, json: "FollowMock").sink { _ in
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.updateFollowResult(response))
        }.store(in: &cancellables)
    }
    
    private func searchUserProfile() {
        
        searcher.searchUserProfile(query: searchUserEmail).sink { _ in
        } receiveValue: { [weak self] response in
            self?.userProfile = response
        }.store(in: &cancellables)
        
        searcher.searchPost(query: searchUserEmail).sink { _ in
        } receiveValue: { [weak self] response in
            self?.posts = response
            self?.outputSubject.send(.updateUserPost(response))
        }.store(in: &cancellables)
        
    }
    
    private func searchMockUserProfile(userId: String) {
        searcher.searchMockUserProfile(query: userId, json: "UserInfoMock").sink { _ in
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.updateUserProfile(response))
        }.store(in: &cancellables)
    }
}

// MARK: - PostCollectionView Delegate
extension UserInfoViewModel: PostCollectionViewProtocol {
    
    func navigateToProfileView(email: String) {
        self.outputSubject.send(.navigateToProfileView(email))
    }
    
    func navigateToReadView(postId: Int) {
        self.outputSubject.send(.navigateToReadView(postId))
    }
    
}
