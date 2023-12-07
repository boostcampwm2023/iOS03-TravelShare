//
//  SceneDelegate.swift
//  Macro
//
//  Created by 김경호 on 11/13/23.
//

import AuthenticationServices
import Combine
import CoreLocation
import Network
import MacroNetwork
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
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
        
        loginStateSubject.value = TokenManager.isTokenExpired()
        
        checkMonitoring()
        bind()
    }
    
}

// MARK: - Methods
extension SceneDelegate {
    func switchViewController(for loginState: LoginState) {
        
        switch loginState {
        case .loggedIn:
            if TokenManager.refreshToken(cancellables: &cancellables) {
                let tabbarViewModel = TabBarViewModel()
                let tabbarViewController = TabBarViewController(viewModel: tabbarViewModel)
                self.navigationController = UINavigationController(rootViewController: tabbarViewController)
                self.window?.rootViewController = self.navigationController
            } else {
                loginStateSubject.value = .loggedOut
            }
        case .loggedOut:
            let provider = APIProvider(session: URLSession.shared)
            let repository = LoginRepository(provider: provider)
            let useCase = AppleLoginUseCase(repository: repository)
            let viewModel = LoginViewModel(loginUseCase: useCase)
            let loginViewController = LoginViewController(viewModel: viewModel,
                                                          loginStateSubject: loginStateSubject)
            self.navigationController = UINavigationController(rootViewController: loginViewController)
            self.window?.rootViewController = self.navigationController
        }
        
        self.window?.makeKeyAndVisible()
    }
}

private extension SceneDelegate {
    
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
