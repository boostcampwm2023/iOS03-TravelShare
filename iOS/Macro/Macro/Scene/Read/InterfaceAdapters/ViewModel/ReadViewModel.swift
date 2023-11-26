//
//  ReadViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation

class ReadViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let useCase: ReadPostUseCaseProtocol
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // MARK: - init
    init(useCase: ReadPostUseCaseProtocol) {
        self.useCase = useCase
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
    }
    
    // MARK: - Methods
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
}

// MARK: - Methods
private extension ReadViewModel {
    func updateReadViewItems() {
        useCase.execute(postId: "1")
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Token Get Fail : ", error)
                }
            } receiveValue: { [weak self] readPost in
                self?.outputSubject.send(.updatePost(post: readPost))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Metohds
private extension ReadViewModel {
    private func searchUser(id: String) {
        self.outputSubject.send(.navigateToProfileView(id))
    }
}
