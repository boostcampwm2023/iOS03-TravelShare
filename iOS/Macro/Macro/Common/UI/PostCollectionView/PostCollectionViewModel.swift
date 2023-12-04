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
    enum Input {
        case navigateToReadView(Int)
    }
    
    enum Output {
        case navigateToReadView(Int)
        case navigateToProfileView(String)
        case updatePostLike(LikePostResponse)
        case updateUserFollow(FollowPatchResponse)
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
            case let .navigateToReadView(postId):
                self?.navigateToReadView(postId: postId)
            }
        }.store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
    func navigateToReadView(postId: Int) {
        self.outputSubject.send(.navigateToReadView(postId))
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
    
    func touchFollow(email: String) {
        patcher.patchFollow(email: email).sink { _ in
        } receiveValue: { [weak self] followPatchResponse in
            self?.outputSubject.send(.updateUserFollow(followPatchResponse))
        }
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
