//
//  ReadViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import UIKit.UIImage

final class ReadViewModel: ViewModelProtocol, CarouselViewProtocol {
    
    // MARK: - Properties
    var pageIndex = 0 {
        didSet {
            self.outputSubject.send(.updatePageIndex(pageIndex))
        }
    }
    
    var carouselCurrentIndex: Int = 0
    var items: [UIImage?] = []
    private var cancellables = Set<AnyCancellable>()
    private let useCase: ReadPostUseCaseProtocol
    private let reporter: ReportUseCase
    private let pathcher: PatchUseCase
    private var readPost: ReadPost?
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let postId: Int
    private var userEmail: String?
    
    // MARK: - Init
    
    init(useCase: ReadPostUseCaseProtocol,
         postId: Int,
         pathcher: PatchUseCase,
         reporter: ReportUseCase) {
        self.useCase = useCase
        self.postId = postId
        self.pathcher = pathcher
        self.reporter = reporter
    }
    
    // MARK: - Input
    
    enum Input {
        case readPosts
        case searchUser
        case likeImageTap
        case reportPost(String, String, String)
        case didDisappear
    }
    
    // MARK: - Output
    
    enum Output {
        case updatePost(post: ReadPost)
        case navigateToProfileView(String)
        case updatePageIndex(Int)
        case updatePostLike(LikePostResponse)
        case updatePostCollection(ReadPost?)
    }
}

// MARK: - Methods

extension ReadViewModel {
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .readPosts:
                    self?.updateReadViewItems()
                case .searchUser:
                    self?.searchUser(id: self?.userEmail ?? "")
                case .likeImageTap:
                    self?.like()
                case let .reportPost(postId, title, description):
                    self?.reportPost(postId: postId, title: title, description: description)
                case .didDisappear:
                    self?.outputSubject.send(.updatePostCollection(self?.readPost))
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
    func updateReadViewItems() {
        useCase.execute(postId: postId)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Read Get Fail : ", error)
                }
            } receiveValue: { [weak self] readPost in
                self?.userEmail = readPost.writer.email
                self?.readPost = readPost
                self?.outputSubject.send(.updatePost(post: readPost))
            }
            .store(in: &cancellables)
    }
    
    private func searchUser(id: String) {
        self.outputSubject.send(.navigateToProfileView(id))
    }
    
    private func like() {
        pathcher.patchPostLike(postId: postId).sink { _ in
        } receiveValue: { [weak self] likePostResponse in
            guard likePostResponse.postId == self?.postId else { return }
            self?.readPost?.liked = likePostResponse.liked
            self?.readPost?.likeNum = likePostResponse.likeNum
            self?.outputSubject.send(.updatePostLike(likePostResponse))
        }.store(in: &cancellables)
    }
    
    private func reportPost(postId: String, title: String, description: String) {
        reporter.reportPost(postId: postId, title: title, description: description).sink { _ in
        } receiveValue: { _ in
        }.store(in: &cancellables)
    }
}
