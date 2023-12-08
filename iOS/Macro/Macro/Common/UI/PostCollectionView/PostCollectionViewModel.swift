//
//  PostCollectionViewModel.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import Combine
import Foundation
import MacroNetwork
import UIKit

final class PostCollectionViewModel: ViewModelProtocol {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PostFindResponseHashable>!
    private var dataTask: URLSessionDataTask?
    var posts: [PostFindResponseHashable] = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    let followFeatrue: FollowUseCase
    let patcher: PatchUseCase
    let postSearcher: SearchUseCase
    var isLastPost: Bool = false
    private let sceneType: SceneType
    var query: String?
    
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
    
    init(followFeature: FollowUseCase, patcher: PatchUseCase, postSearcher: SearchUseCase, sceneType: SceneType) {
        self.followFeatrue = followFeature
        self.patcher = patcher
        self.postSearcher = postSearcher
        self.sceneType = sceneType
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
        if let index = posts.firstIndex(where: { $0.postFindResponse.postId == postId }) {
            posts[index].postFindResponse.viewNum += 1
            outputSubject.send(.updatePostView(postId, posts[index].postFindResponse.viewNum))
        }
    }
    
    func getNextPost(_ pageNum: Int) {
        let publisher: AnyPublisher<[PostFindResponse], NetworkError>
        
        switch sceneType {
        case .home:
            publisher = postSearcher.fetchHitPost(postCount: posts.count)
        case .relatedPost:
            publisher = postSearcher.searchRelatedPost(query: query ?? "", postCount: posts.count)
        case .searchPostTitle:
            publisher = postSearcher.searchPostTitle(query: query ?? "", postCount: posts.count)
        case .userInfoPost:
            publisher = postSearcher.searchPost(query: query ?? "", postCount: posts.count)
        }
        publisher.sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: { [weak self] response in
            let sortedResponse = response.sorted { $0.postId > $1.postId }
            let sortedResponseHashable = sortedResponse.map { PostFindResponseHashable(postFindResponse: $0) }
            if sortedResponseHashable.count < 10 {
                self?.isLastPost = true
            }
            self?.posts += sortedResponseHashable
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
        
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            let image = UIImage(data: cachedResponse.data)
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            self.dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                if let data = data, let image = UIImage(data: data) {
                    let cachedResponse = CachedURLResponse(response: response!, data: data)
                                       URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            }
            self.dataTask?.resume()
        }
    }
    
    func cancelLoadingImage(itemName: String?) {
        print("cancel \(itemName)")
        dataTask?.cancel()
        dataTask = nil
    }
}

    enum Section {
        case main
    }
