//
//  UserAgreementViewController.swift
//  Macro
//
//  Created by Byeon jinha on 12/13/23.
//

import Combine
import UIKit

final class UserAgreementViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: UserAgreementViewModel
    internal let inputSubject: PassthroughSubject<UserAgreementViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let userAgreementHeaderView: UserAgreementHeaderView = UserAgreementHeaderView()
    
    private lazy var totalAgreementView: UserAgreementTapView = UserAgreementTapView(agreement: viewModel.totalAgreement, viewModel: viewModel)
    private lazy var searviceAgreementView: UserAgreementTapView = UserAgreementTapView(agreement: viewModel.serviceAgreement, viewModel: viewModel)
    private lazy var personalAgreementView: UserAgreementTapView = UserAgreementTapView(agreement: viewModel.personalAgreement, viewModel: viewModel)
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.appFont(.baeEunTitle1)
        button.setTitleColor(UIColor.appColor(.blue1), for: .normal)
        button.backgroundColor = UIColor.appColor(.isInactive)
        button.layer.cornerRadius = 15
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.appColor(.blue1)
        setUpLayout()
        bind()
    }
    
    init(viewModel: UserAgreementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

extension UserAgreementViewController {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        userAgreementHeaderView.translatesAutoresizingMaskIntoConstraints = false
        totalAgreementView.translatesAutoresizingMaskIntoConstraints = false
        searviceAgreementView.translatesAutoresizingMaskIntoConstraints = false
        personalAgreementView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        view.addSubview(userAgreementHeaderView)
        view.addSubview(totalAgreementView)
        view.addSubview(searviceAgreementView)
        view.addSubview(personalAgreementView)
        view.addSubview(confirmButton)
        
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            userAgreementHeaderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            userAgreementHeaderView.widthAnchor.constraint(equalToConstant: UIScreen.width - 100),
            userAgreementHeaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            totalAgreementView.topAnchor.constraint(equalTo: userAgreementHeaderView.topAnchor, constant: 60),
            totalAgreementView.widthAnchor.constraint(equalToConstant: UIScreen.width - 56),
            totalAgreementView.heightAnchor.constraint(equalToConstant: 50),
            totalAgreementView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            searviceAgreementView.topAnchor.constraint(equalTo: totalAgreementView.topAnchor, constant: 60),
            searviceAgreementView.widthAnchor.constraint(equalToConstant: UIScreen.width - 56),
            searviceAgreementView.heightAnchor.constraint(equalToConstant: 50),
            searviceAgreementView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            personalAgreementView.topAnchor.constraint(equalTo: searviceAgreementView.topAnchor, constant: 60),
            personalAgreementView.widthAnchor.constraint(equalToConstant: UIScreen.width - 56),
            personalAgreementView.heightAnchor.constraint(equalToConstant: 50),
            personalAgreementView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            confirmButton.widthAnchor.constraint(equalToConstant: UIScreen.width - 90),
            confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - Bind
extension UserAgreementViewController {
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case .changeButton:
                self?.changeButton()
            case .navigateToHomeView:
                self?.navigateToHomeView()
            }
        }.store(in: &cancellables)
    }
    
}

// MARK: - Methods
private extension UserAgreementViewController {
    
    func navigateToHomeView() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.switchViewController(for: .loggedIn)
    }
    
    func changeButton() {
        totalAgreementView.updateCheck(isCheck: viewModel.totalAgreement.isCheck)
        searviceAgreementView.updateCheck(isCheck: viewModel.serviceAgreement.isCheck)
        personalAgreementView.updateCheck(isCheck: viewModel.personalAgreement.isCheck)
        confirmButton.backgroundColor = viewModel.totalAgreement.isCheck ? UIColor.appColor(.purple2) : UIColor.appColor(.isInactive)
        confirmButton.isEnabled = viewModel.totalAgreement.isCheck
    }
}

// MARK: - Authentication

extension UserAgreementViewController {
    
    @objc func confirmPressed() {
        inputSubject.send(.completeAgree)
        dismiss(animated: true)
    }
    
}
