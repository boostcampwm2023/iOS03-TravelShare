//
//  PostCollectionViewModel.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import Combine
import Foundation
import MacroNetwork

// TODO: ViewModel에서 UIKit 지우기. 현재 loadImage 부분 때문에 import 중입니다.
import UIKit

final class PostCollectionViewModel: ViewModelProtocol {
    
    var posts: [PostFindResponse] = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    let followFeatrue: FollowUseCase
    let patcher: PatchUseCase
    let postSearcher: SearchUseCase
    var isLastPost: Bool = false
    
    enum Input {
        case navigateToReadView(Int)
        case touchLike(Int)
        case increaseView(Int)
        case getNextPost(Int)
    }
    
    enum Output {
        case navigateToReadView(Int)
        case navigateToProfileView(String)
        case updatePostLike(LikePostResponse)
        case updateUserFollow(FollowPatchResponse)
        case updatePostView(Int, Int)
        case updatePostContnet
    }
    
    init(posts: [PostFindResponse], followFeature: FollowUseCase, patcher: PatchUseCase, postSearcher: SearchUseCase) {
        self.posts = posts
        self.followFeatrue = followFeature
        self.patcher = patcher
        self.postSearcher = postSearcher
    }
    
}

extension PostCollectionViewModel {
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case let .touchLike(postId):
                self?.touchLike(postId: postId)
            case let .increaseView(postId):
                self?.increasePostView(postId)
            case let .getNextPost(pageNum):
                self?.getNextPost(pageNum)
            default: break
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    func increasePostView(_ postId: Int) {
        if let index = posts.firstIndex(where: { $0.postId == postId }) {
            posts[index].viewNum += 1
            outputSubject.send(.updatePostView(postId, posts[index].viewNum))
        }
    }

    func getNextPost(_ pageNum: Int) {
        postSearcher.fetchHitPost(postCount: posts.count).sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: { [weak self] response in
            if response.count < 10 {
                self?.isLastPost = true
            }
            print(response.count, self?.isLastPost)
            self?.posts += response
            self?.outputSubject.send(.updatePostContnet)
        }.store(in: &cancellables)
    }
    
    func navigateToProfileView(email: String) {
        self.outputSubject.send(.navigateToProfileView(email))
    }
    
    func touchLike(postId: Int) {
        patcher.patchPostLike(postId: postId).sink { _ in
        } receiveValue: { [weak self] likePostResponse in
            self?.outputSubject.send(.updatePostLike(likePostResponse))
        }.store(in: &cancellables)
    }
    
    func loadImage(profileImageStringURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: profileImageStringURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
