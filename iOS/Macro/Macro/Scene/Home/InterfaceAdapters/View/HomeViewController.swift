//
//  HomeViewController.swift
//  Macro
//
//  Created by 김경호 on 11/13/23.
//

import Combine
import MacroNetwork
import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let homeHeaderView: HomeHeaderView = HomeHeaderView()
    lazy var homeCollectionView: HomeCollectionView = HomeCollectionView(frame: .zero, collectionViewLayout: homeCollectionViewLayout)
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private let inputSubject: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private let provider = APIProvider(session: URLSession.shared)
    private var cancellables = Set<AnyCancellable>()
    private var homeCollectionViewLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = HomeViewModel(postSearcher: PostSearcher(provider: provider))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.appColor(.blue1)
        bind()
        inputSubject.send(.searchMockPost)
        setUpLayout()
    }
    
}

// MARK: UI Settings

extension HomeViewController {

    func setTranslatesAutoresizingMaskIntoConstraints() {
        homeHeaderView.translatesAutoresizingMaskIntoConstraints = false
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    func addsubviews() {
        self.view.addSubview(homeHeaderView)
        self.view.addSubview(homeCollectionView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            homeHeaderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Padding.homeHeaderViewTop),
            homeHeaderView.heightAnchor.constraint(equalToConstant: Metrics.homeHeaderViewHeight),
            homeHeaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            homeHeaderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            homeCollectionView.topAnchor.constraint(equalTo: homeHeaderView.bottomAnchor, constant: Padding.homeCollectionViewTop),
            homeCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
}

extension HomeViewController {
    
    func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        homeHeaderView.setUpLayout()
    }
    
}

// MARK: - Methods

private extension HomeViewController {
    
    func updateSearchResult(_ result: [PostResponse]) {
        homeCollectionView.posts = result
        homeCollectionView.reloadData()
    }
    
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

// MARK: - LayoutMetrics

private extension HomeViewController {
    
    enum Metrics {
        static let homeHeaderViewHeight: CGFloat = 60
    }

    enum Padding {
        static let homeHeaderViewTop: CGFloat = 50
        static let homeCollectionViewTop: CGFloat = 10
    }
}
