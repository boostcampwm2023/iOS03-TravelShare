//
//  HomeViewController.swift
//  Macro
//
//  Created by 김경호 on 11/13/23.
//

import Combine
import MacroNetwork
import UIKit

final class HomeViewController: UIViewController, PostCollectionViewDelegate {

    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private let inputSubject: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private let provider = APIProvider(session: URLSession.shared)
    private var cancellables = Set<AnyCancellable>()
    let postCollectionViewModel = PostCollectionViewModel(posts: [], followFeature: FollowFeature(provider: APIProvider(session: URLSession.shared)), patcher: Patcher(provider: APIProvider(session: URLSession.shared)), postSearcher: Searcher(provider: APIProvider(session: URLSession.shared)))
    
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
        inputSubject.send(.searchPosts)
        setUpLayout()
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

extension HomeViewController {
    
    private func updateSearchResult(_ result: [PostFindResponse]) {
        _ = result.sorted { $0.postId < $1.postId }
        postCollectionView.viewModel.posts = result
        postCollectionView.reloadData()
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
        postCollectionView.reloadData()
    }
    
    func didTapContent(viewController: ReadViewController) {
        print(123)
        navigationController?.pushViewController(viewController, animated: true)
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
