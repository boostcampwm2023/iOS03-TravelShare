//
//  SceneDelegate.swift
//  Macro
//
//  Created by 김경호 on 11/13/23.
//

import AuthenticationServices
import Combine
import Network
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    
    private let queue = DispatchQueue(label: Label.queueLabel)
    private let monitor = NWPathMonitor()
    private let networkStatusSubject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var loginStateSubject = CurrentValueSubject<LoginState, Never>(.loggedOut)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        checkMonitoring()
        bind()
        
    }
    
}

// MARK: - Methods
private extension SceneDelegate {
    
    func switchViewController(for loginState: LoginState) {
        
        switch loginState {
        case .loggedIn:
            let tabbarViewModel = TabBarViewModel()
            let tabbarViewController = TabbarViewController(viewModel: tabbarViewModel)
            self.navigationController = UINavigationController(rootViewController: tabbarViewController)
            self.window?.rootViewController = self.navigationController
        case .loggedOut:
            let repository = MockLoginRepository()
            let useCase = AppleLoginUseCase(repository: repository)
            let viewModel = LoginViewModel(loginUseCase: useCase)
            let loginViewController = LoginViewController(viewModel: viewModel,
                                                          loginStateSubject: loginStateSubject)
            self.navigationController = UINavigationController(rootViewController: loginViewController)
            self.window?.rootViewController = self.navigationController
        }
        
        self.window?.makeKeyAndVisible()
    }
    
    func bind() {
        networkStatusSubject
            .sink {  [weak self] isNetworkAvailable in
                self?.checkMonitoring()
            }
            .store(in: &cancellables)
        
        loginStateSubject
            .sink { [weak self] isLogIntate in
                self?.switchViewController(for: isLogIntate)
            }
            .store(in: &cancellables)
    }
    
    func checkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isNetworkAvailable = (path.status == .satisfied)
            DispatchQueue.main.async {
                if !isNetworkAvailable {
                    self?.showNetworkUnresearchableViewController()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func showNetworkUnresearchableViewController() {
        guard let navigationController = self.navigationController else { return }
        let networkUnresearchableViewController = NetworkUnresearchableViewController(monitor: monitor,
                                                                                      networkStatusSubject: networkStatusSubject)
        navigationController.pushViewController(networkUnresearchableViewController, animated: true)
    }
}

// MARK: - LayoutMetrics
private extension SceneDelegate {
    enum Label {
        static let queueLabel: String = "NetworkMonitor"
    }
}

enum LoginState {
    case loggedIn
    case loggedOut
}
