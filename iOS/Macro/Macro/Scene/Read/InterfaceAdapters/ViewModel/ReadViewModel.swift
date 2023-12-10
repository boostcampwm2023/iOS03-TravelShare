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
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let postId: Int
    
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
        case searchUser(String)
        case likeImageTap
        case reportPost(String, String, String)
    }
    
    // MARK: - Output
    
    enum Output {
        case updatePost(post: ReadPost)
        case navigateToProfileView(String)
        case updatePageIndex(Int)
        case updatePostLike(LikePostResponse)
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
                case let .searchUser(userID):
                    self?.searchUser(id: userID)
                case .likeImageTap:
                    self?.like()
                case let .reportPost(postId, title, description):
                    self?.reportPost(postId: postId, title: title, description: description)
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
    func reportPost() {
        
    }
    
    func updateReadViewItems() {
        useCase.execute(postId: postId)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Read Get Fail : ", error)
                }
            } receiveValue: { [weak self] readPost in
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
            self?.outputSubject.send(.updatePostLike(likePostResponse))
        }.store(in: &cancellables)
    }
    
    private func reportPost(postId: String, title: String, description: String) {
        reporter.reportPost(postId: postId, title: title, description: description).sink { _ in
        } receiveValue: { _ in
        }.store(in: &cancellables)
    }
}
