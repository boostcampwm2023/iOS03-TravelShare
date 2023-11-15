//
//  LoginViewController.swift
//  Macro
//
//  Created by 김경호 on 11/14/23.
//

import AuthenticationServices
import Combine
import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: LoginViewModel
    private var cacheManger: CacheManager = CacheManager()
    private let inputSubject: PassthroughSubject<LoginViewModel.Input, Never> = .init()
    
    // MARK: - UI Componenets
    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - init
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error: 스토리보드 말고 코드를 사용해서 구현해주세요.")
    }
}

// MARK: - UI Setting
private extension LoginViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(appleLoginButton)
        
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            appleLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
    }
}

// MARK: - bind
private extension LoginViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case.appleLoginCompleted:
                    self?.navigationController?.setViewControllers([HomeViewController()], animated: true)
                }
            }
            .store(in: &subscriptions)
    }
}


// MARK: - Apple Login
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            debugPrint("Login 성공")
            if let authorizationCode = appleIDCredential.authorizationCode, 
                let identityToken = appleIDCredential.identityToken,
               let authCodeString = String(data: authorizationCode, encoding: .utf8),
               let identifyTokenString = String(data: identityToken, encoding: .utf8)
            {
                inputSubject.send(.appleLogin(
                    identityToken: identifyTokenString,
                    authorizationCode: authCodeString))
            }
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        debugPrint("User 인증 실패 : \(error.localizedDescription)")
    }
    
    // MARK: - objc
    @objc private func loginButtonDidTap() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
