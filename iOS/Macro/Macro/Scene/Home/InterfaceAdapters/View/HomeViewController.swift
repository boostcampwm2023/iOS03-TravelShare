//
//  HomeViewController.swift
//  Macro
//
//  Created by 김경호 on 11/13/23.
//

import Combine
import MacroNetwork
import UIKit

final class HomeViewController: TouchableViewController {

    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private let inputSubject: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private let provider = APIProvider(session: URLSession.shared)
    private var cancellables = Set<AnyCancellable>()
    private let readViewDisappear: PassthroughSubject<LikePostResponse, Never> = .init()
    let postCollectionViewModel = PostCollectionViewModel( followFeature: FollowFeature(provider: APIProvider(session: URLSession.shared)), patcher: Patcher(provider: APIProvider(session: URLSession.shared)), postSearcher: Searcher(provider: APIProvider(session: URLSession.shared)), sceneType: .home)
    
    // MARK: - UI Components
    
    lazy var postCollectionView: PostCollectionView = {
           let collectionView = PostCollectionView(frame: .zero, viewModel: postCollectionViewModel)
           return collectionView
       }()
    
    private let homeHeaderView: HomeHeaderView = HomeHeaderView()
    
    // MARK: - Init
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.appColor(.blue1)
        bind()
        postCollectionView.postDelegate = self
        postCollectionView.readViewDisappear = self.readViewDisappear
        setUpLayout()
        inputSubject.send(.searchPosts(0))
    }
    
}

// MARK: - UI Settings

extension HomeViewController {

    private func setTranslatesAutoresizingMaskIntoConstraints() {
        homeHeaderView.translatesAutoresizingMaskIntoConstraints = false
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func addsubviews() {
        self.view.addSubview(homeHeaderView)
        self.view.addSubview(postCollectionView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            homeHeaderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Padding.homeHeaderViewTop),
            homeHeaderView.heightAnchor.constraint(equalToConstant: Metrics.homeHeaderViewHeight),
            homeHeaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            homeHeaderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            postCollectionView.topAnchor.constraint(equalTo: homeHeaderView.bottomAnchor, constant: Padding.homeCollectionViewTop),
            postCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            postCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            postCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        homeHeaderView.setUpLayout()
    }
}

// MARK: - Bind

private extension HomeViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .updateSearchResult(result):
                self?.updateSearchResult(result)
            default: break
            }
        }.store(in: &cancellables)
        
        readViewDisappear
            .receive(on: DispatchQueue.main)
            .sink { [weak self] likeInfo in
                self?.updateLikeInfo(likeInfo)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

extension HomeViewController {
    
    private func updateSearchResult(_ result: [PostFindResponse]) {
        _ = result.sorted { $0.postId < $1.postId }
        postCollectionView.viewModel.posts = result
        postCollectionView.reloadData()
    }
    
    private func updateLikeInfo(_ likeInfo: LikePostResponse) {
        postCollectionView.viewModel.posts.enumerated().forEach {
            if $1.postId == likeInfo.postId {
                var post = postCollectionView.viewModel.posts[$0]
                post.likeNum = likeInfo.likeNum
                post.liked = likeInfo.liked
                
                postCollectionView.viewModel.posts[$0] = post
                postCollectionView.reloadData()
            }
        }
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
