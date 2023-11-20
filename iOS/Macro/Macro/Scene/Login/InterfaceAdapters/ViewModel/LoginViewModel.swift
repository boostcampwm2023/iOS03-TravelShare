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
        case appleLogin(identityToken: String, authorizationCode: String)
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
                case let .appleLogin(identityToken, authorizationCode):
                    self?.requestToken(identityToken: identityToken, authorizationCode: authorizationCode)
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func requestToken(identityToken: String, authorizationCode: String) {
        loginUseCase.execute(requestValue: LoginRequest(identityToken: identityToken, authorizationCode: authorizationCode))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    debugPrint(#function, "Login Fail : \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                switch response {
                case .success:
                    self?.outputSubject.send(.appleLoginCompleted)
                case .failure:
                    debugPrint(#function, "Token Get Fail")
                }
            }
            .store(in: &subscriptions)
    }
}
