//
//  UserInfoViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import UIKit

final class UserInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: UserInfoViewModel
    private let inputSubject: PassthroughSubject<UserInfoViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    lazy var homeCollectionView: PostCollectionView = PostCollectionView(frame: .zero, viewModel: viewModel)
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.appColor(.blue1)
        bind()
        inputSubject.send(.searchMockPost)
        setUpLayout()
        super.viewDidLoad()
    }
    
    // MARK: - Init
    
    init(viewModel: UserInfoViewModel, userInfo: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        label.text = userInfo
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

private extension UserInfoViewController {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.view.addSubview(label)
        self.view.addSubview(homeCollectionView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            homeCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            homeCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - Binding

private extension UserInfoViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .updateSearchResult(result):
                self?.updateSearchResult(result)
            default: break
            }
        }.store(in: &cancellables)
        
    }
}

// MARK: - Methods

private extension UserInfoViewController {
    func updateSearchResult(_ result: [PostFindResponse]) {
        homeCollectionView.viewModel.posts += result
        homeCollectionView.reloadData()
    }
}
