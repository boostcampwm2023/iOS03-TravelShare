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
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private let inputSubject: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private let provider = APIProvider(session: URLSession.shared)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let homeHeaderView: HomeHeaderView = HomeHeaderView()
    lazy var homeCollectionView: PostCollectionView = PostCollectionView(frame: .zero, viewModel: viewModel)
    
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
        inputSubject.send(.searchPosts)
        setUpLayout()
    }
    
}

// MARK: - UI Settings

extension HomeViewController {

    private func setTranslatesAutoresizingMaskIntoConstraints() {
        homeHeaderView.translatesAutoresizingMaskIntoConstraints = false
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func addsubviews() {
        self.view.addSubview(homeHeaderView)
        self.view.addSubview(homeCollectionView)
    }
    
    private func setLayoutConstraints() {
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
            case let .navigateToProfileView(email):
                self?.navigateToProfileView(email)
            case let .navigateToReadView(postId):
                self?.navigateToReadView(postId)
            case let .updatePostLike(likePostResponse):
                self?.updatePostLike(likePostResponse)
            default: break
            }
        }.store(in: &cancellables)
    }
}

// MARK: - Methods

private extension HomeViewController {
    
    private func updateSearchResult(_ result: [PostFindResponse]) {
        _ = result.sorted { $0.postId < $1.postId }
        homeCollectionView.viewModel.posts = result
        homeCollectionView.reloadData()
    }
    
    private func navigateToProfileView(_ email: String) {
        let userInfoViewModel = UserInfoViewModel(postSearcher: viewModel.postSearcher,
                                                  followFeature: viewModel.followFeatrue,
                                                  patcher: Patcher(provider: provider))
        let userInfoViewController = UserInfoViewController(viewModel: userInfoViewModel, userInfo: email)
        navigationController?.pushViewController(userInfoViewController, animated: true)
    }
    
    private func navigateToReadView(_ postId: Int) {
        let provider = APIProvider(session: URLSession.shared)
        let readuseCase = ReadPostUseCase(provider: provider)
        let readViewModel = ReadViewModel(useCase: readuseCase, postId: postId)
        let readViewController = ReadViewController(viewModel: readViewModel)

        navigationController?.pushViewController(readViewController, animated: true)
    }
    
    private func updatePostLike(_ likePostReponse: LikePostResponse) {
        guard let post = viewModel.posts.first(where: { $0.postId == likePostReponse.postId }) else { return }
        guard let index = viewModel.posts.firstIndex(where: { $0.postId == post.postId }) else { return }
        viewModel.posts[index].liked = likePostReponse.liked
        viewModel.posts[index].likeNum = likePostReponse.likeNum
        homeCollectionView.reloadData()
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
