//
//  LoginViewController.swift
//  Macro
//
//  Created by 김경호 on 11/14/23.
//

import AuthenticationServices
import Combine
import MacroDesignSystem
import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: LoginViewModel
    private var cacheManger: CacheManager = CacheManager()
    private let inputSubject: PassthroughSubject<LoginViewModel.Input, Never> = .init()
    private let loginStateSubject: CurrentValueSubject<LoginState, Never>
    
    // MARK: - UI Componenets
    
    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    private let loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LoginImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.text = "어디갈래?"
        label.textColor = UIColor.appColor(.purple3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunTitle1)
        label.text = "여행으로 여행을 만든다.\n같이 여행을 떠나볼까요?"
        label.textColor = UIColor.appColor(.purple2)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
    }
    
    // MARK: - Init
    init(viewModel: LoginViewModel, loginStateSubject: CurrentValueSubject<LoginState, Never>) {
        self.viewModel = viewModel
        self.loginStateSubject = loginStateSubject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error: 스토리보드 말고 코드를 사용해서 구현해주세요.")
    }
}

// MARK: - UI Settings

private extension LoginViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        [loginImageView, titleLabel, keywordLabel, appleLoginButton].forEach {
            view.addSubview($0)
        }
        
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginImageView.heightAnchor.constraint(equalToConstant: 140),
            loginImageView.widthAnchor.constraint(equalToConstant: 200),
            loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: loginImageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: loginImageView.leadingAnchor),
            
            keywordLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            keywordLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            appleLoginButton.widthAnchor.constraint(equalToConstant: UIScreen.width - 150),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
}

// MARK: - Bind
private extension LoginViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case.appleLoginCompleted:
                    self?.loginStateSubject.value = .loggedIn
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
            if let identityToken = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityToken, encoding: .utf8),
               let authorizationCode = appleIDCredential.authorizationCode,
               let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) {
                
                KeyChainManager.save(key: KeychainKey.identityToken, token: identityTokenString)
                KeyChainManager.save(key: KeychainKey.authorizationCode, token: authorizationCodeString)
                
                inputSubject.send(
                    .appleLogin(identityToken: identityTokenString))
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

// MARK: - LayoutMetrics
private extension LoginViewController {
    enum KeychainKey {
        static let identityToken: String = "IdentityToken"
        static let authorizationCode: String = "AuthorizationCode"
    }
}
