//
//  UserInfoViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import UIKit
import MacroNetwork

final class UserInfoViewController: TouchableViewController {
    
    // MARK: - Properties
    
    private let viewModel: UserInfoViewModel
    let postCollectionViewModel = PostCollectionViewModel(followFeature: FollowFeature(provider: APIProvider(session: URLSession.shared)), patcher: Patcher(provider: APIProvider(session: URLSession.shared)), postSearcher: Searcher(provider: APIProvider(session: URLSession.shared)), sceneType: .userInfoPost)
    private let inputSubject: PassthroughSubject<UserInfoViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    lazy var userInfoHeaderView: UserInfoHeaderView = UserInfoHeaderView(frame: .zero, inputSubject: inputSubject, viewModel: viewModel)
    
    // MARK: - UI Components
    
    private let homeHeaderView: HomeHeaderView = HomeHeaderView()
    
    lazy var postCollectionView: PostCollectionView = {
        let collectionView = PostCollectionView(frame: .zero, viewModel: postCollectionViewModel)
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.appColor(.blue1)
        bind()
        inputSubject.send(.searchUserProfile(email: viewModel.searchUserEmail))
        setUpLayout()
        postCollectionView.postDelegate = self
    }
    
    // MARK: - Init
    
    init(viewModel: UserInfoViewModel, userInfo: String) {
        self.viewModel = viewModel
        viewModel.searchUserEmail = userInfo
        postCollectionViewModel.query = userInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

private extension UserInfoViewController {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        userInfoHeaderView.translatesAutoresizingMaskIntoConstraints = false
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        self.view.addSubview(userInfoHeaderView)
        self.view.addSubview(postCollectionView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            userInfoHeaderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            userInfoHeaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            userInfoHeaderView.widthAnchor.constraint(equalToConstant: UIScreen.width - 40),
            userInfoHeaderView.heightAnchor.constraint(equalToConstant: 217),
            
            postCollectionView.topAnchor.constraint(equalTo: userInfoHeaderView.bottomAnchor, constant: 20),
            postCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            postCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            postCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - Bind

private extension UserInfoViewController {
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .updateUserProfile(result):
                self?.updateUserProfile(result)
            case let .updateUserPost(result):
                self?.updateUserPost(result)
            default: break
            }
        }.store(in: &cancellables)
        
    }
}

// MARK: - Methods

private extension UserInfoViewController {
    
    private func updateUserProfile(_ result: UserProfile) {
        userInfoHeaderView.configure(item: result)
        userInfoHeaderView.updateFollow(item: result)
    }
    
    private func updateUserPost(_ result: [PostFindResponse]) {
        postCollectionView.viewModel.posts = result
        postCollectionView.reloadData()
    }
}
