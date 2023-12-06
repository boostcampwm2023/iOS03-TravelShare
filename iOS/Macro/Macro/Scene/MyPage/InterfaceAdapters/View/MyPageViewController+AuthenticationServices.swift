//
//  MyPageViewController+AuthenticationServices.swift
//  Macro
//
//  Created by Byeon jinha on 12/6/23.
//

import AuthenticationServices
import UIKit

extension MyPageViewController {
    func tryRevoke() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.switchViewController(for: .loggedOut)
        
        guard let identityToken = KeyChainManager.load(key: KeychainKey.identityToken),
              let authorizationCode = KeyChainManager.load(key: KeychainKey.authorizationCode)
        else { return }
        inputSubject.send(.appleLogout(identityToken: identityToken, authorizationCode: authorizationCode))
    }
    
    func completeRevoke() {
        KeyChainManager.delete(key: KeychainKey.accessToken)
        KeyChainManager.delete(key: KeychainKey.authorizationCode)
        KeyChainManager.delete(key: KeychainKey.identityToken)
    }
}

// MARK: - LayoutMetrics
private extension MyPageViewController {
    enum KeychainKey {
        static let accessToken: String = "AccessToken"
        static let authorizationCode: String = "AuthorizationCode"
        static let identityToken: String = "IdentityToken"
    }
}
