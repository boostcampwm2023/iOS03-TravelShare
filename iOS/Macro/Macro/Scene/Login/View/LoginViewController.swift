//
//  LoginViewController.swift
//  Macro
//
//  Created by 김경호 on 11/14/23.
//

import UIKit
import AuthenticationServices

final class LoginViewController: UIViewController {
    private var viewModel: LoginViewModelProtocol
    
    // MARK: - UI Componenets
    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - init
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error: 스토리보드 말고 코드를 사용해서 구현해주세요.")
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
            let userIdentifier = appleIDCredential.user
            let identityToken = appleIDCredential.identityToken
        default:
            break
        }
    }
    
    @objc private func loginButtonDidTap() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - UI Setting
private extension LoginViewController {
    func configureUI() {
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
