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
    var navigationController: UINavigationController?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tabbarViewModel = TabBarViewModel()
        let tabbarViewController = TabbarViewController(viewModel: tabbarViewModel)
        
        let rootNavigationController = UINavigationController(rootViewController: tabbarViewController)
        
        window.rootViewController = rootNavigationController
        
        window.makeKeyAndVisible()
        self.window = window
        self.navigationController = rootNavigationController
    }
}
