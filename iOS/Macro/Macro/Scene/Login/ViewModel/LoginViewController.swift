//
//  LoginViewController.swift
//  Macro
//
//  Created by 김경호 on 11/14/23.
//

import UIKit
import AuthenticationServices

final class LoginViewController: UIViewController {
    // MARK: - UI Componenets
    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI Setting
private extension LoginViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(appleLoginButton)
        
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 200),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
    }
}
