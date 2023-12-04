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
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let postId: Int
    
    // MARK: - Init
    
    init(useCase: ReadPostUseCaseProtocol, postId: Int) {
        self.useCase = useCase
        self.postId = postId
    }
    
    // MARK: - Input
    
    enum Input {
        case readPosts
        case searchUser(String)
    }
    
    // MARK: - Output
    
    enum Output {
        case updatePost(post: ReadPost)
        case navigateToProfileView(String)
        case updatePageIndex(Int)
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
                self?.outputSubject.send(.updatePost(post: readPost))
            }
            .store(in: &cancellables)
    }
    
    private func searchUser(id: String) {
        self.outputSubject.send(.navigateToProfileView(id))
    }
}
