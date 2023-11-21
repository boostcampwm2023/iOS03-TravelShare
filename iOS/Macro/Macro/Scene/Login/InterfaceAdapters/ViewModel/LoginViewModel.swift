//
//  LoginViewModel.swift
//  Macro
//
//  Created by 김경호 on 11/15/23.
//

import Combine
import Foundation

final class LoginViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var loginUseCase: AppleLoginUseCaseProtocol
    
    // MARK: - init
    init(loginUseCase: AppleLoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case appleLogin(identityToken: String)
    }
    
    // MARK: - Output

    enum Output {
        case appleLoginCompleted
    }
    
    // MARK: - Methods
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .appleLogin(identityToken):
                    self?.requestToken(identityToken: identityToken)
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func requestToken(identityToken: String) {
        loginUseCase.execute(identityToken: identityToken)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Token Get Fail : ", error)
                }
            } receiveValue: { [weak self] response in
                KeyChainManager.save(key: "AccessToken", token: response.accessToken)
                if let token = KeyChainManager.load(key: "AccessToken") {
                    self?.outputSubject.send(.appleLoginCompleted)
                } else {
                    debugPrint("Access Token 불러오는데 실패했습니다.")
                }
            }
            .store(in: &subscriptions)
    }
}
