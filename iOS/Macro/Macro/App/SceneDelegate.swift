//
//  SceneDelegate.swift
//  Macro
//
//  Created by 김경호 on 11/13/23.
//

import UIKit
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let token = KeyChainManager.load(key: "RefreshToken") ?? ""
        
        appleIDProvider.getCredentialState(forUserID: token) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                window.rootViewController = LoginViewController(viewModel: LoginViewModel())
            default:
                window.rootViewController = HomeViewController()
            }
        }
        
        window.rootViewController = LoginViewController(viewModel: LoginViewModel())
        window.makeKeyAndVisible()
        self.window = window
    }
}
