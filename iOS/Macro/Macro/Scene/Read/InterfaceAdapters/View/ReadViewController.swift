//
//  ReadViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import NMapsMap
import MacroNetwork
import UIKit

final class ReadViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: ReadViewModel
    private let const = MacroCarouselView.Const(itemSize: CGSize(width: UIScreen.width, height: 340), itemSpacing: 24.0)
    private var readPost: ReadPost?
    private var cancellables = Set<AnyCancellable>()
    private let didScrollSubject: PassthroughSubject<Int, Never> = .init()
    private let inputSubject: PassthroughSubject<ReadViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var postProfile: ReadProfileView = {
        let view = ReadProfileView(inputSubject: self.inputSubject)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.blue5)
        label.font = UIFont.appFont(.baeEunTitle1)
        label.textAlignment = .center
        return label
    }()
    
    // TODO: - 이미지 없을 시 처리 할 것
    private lazy var carouselView: MacroCarouselView = {
        let view = MacroCarouselView(const: const, didScrollOutputSubject: didScrollSubject)
        return view
    }()
    
    private var imageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunBody)
        label.textAlignment = .center
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        var configure = UIButton.Configuration.plain()
        let image = UIImage.appImage(.handThumbsup)?
            .withTintColor(UIColor.appColor(.purple5))
        configure.image = image
        configure.imagePadding = 10
        button.configuration = configure
        button.titleLabel?.font = UIFont.appFont(.baeEunBody)
        button.setTitle("0", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let viewButton: UIButton = {
        let button = UIButton()
        var configure = UIButton.Configuration.plain()
        let image = UIImage.appImage(.eyes)?
            .withTintColor(UIColor.appColor(.purple5))
        configure.image = image
        configure.imagePadding = 10
        button.configuration = configure
        button.titleLabel?.font = UIFont.appFont(.baeEunBody)
        button.setTitle("0", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let messageButton: UIButton = {
        let button = UIButton()
        var configure = UIButton.Configuration.plain()
        let image = UIImage.appImage(.paperplane)?
            .withTintColor(UIColor.appColor(.purple5))
        configure.image = image
        configure.imagePadding = 20
        button.configuration = configure
        return button
    }()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.positionMode = .normal
        return mapView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        bind()
        setLayout()
        self.view.backgroundColor = .white
        
        inputSubject.send(.readPosts)
    }
    
    // MARK: - init
    
    init(viewModel: ReadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - bind

private extension ReadViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] output in
                switch output {
                case let .updatePost(post):
                    self?.updatePost(post)
                case let .navigateToProfileView(userID):
                    self?.navigateToProfileView(userID)
                }
            }
            .store(in: &cancellables)
        
        didScrollSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] index in
                self?.imageDescriptionLabel.text = self?.readPost?.contents[index].description
            }
            .store(in: &cancellables)
    }
}

// MARK: - UI

private extension ReadViewController {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        postProfile.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        imageDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollContentView)
        [
            postProfile,
            titleLabel,
            carouselView,
            imageDescriptionLabel,
            likeButton,
            viewButton,
            messageButton,
            mapView
        ].forEach { self.scrollContentView.addSubview($0) }
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            postProfile.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            postProfile.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 10),
            postProfile.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -10),
            postProfile.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: postProfile.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            
            carouselView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            carouselView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: const.itemSize.height),
            
            imageDescriptionLabel.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 30),
            imageDescriptionLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            imageDescriptionLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            imageDescriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            likeButton.topAnchor.constraint(equalTo: imageDescriptionLabel.bottomAnchor, constant: 40),
            likeButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 10),
            
            viewButton.topAnchor.constraint(equalTo: imageDescriptionLabel.bottomAnchor, constant: 40),
            viewButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            
            messageButton.topAnchor.constraint(equalTo: imageDescriptionLabel.bottomAnchor, constant: 40),
            messageButton.leadingAnchor.constraint(equalTo: viewButton.trailingAnchor, constant: 10),
            
            mapView.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            mapView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
            mapView.heightAnchor.constraint(equalToConstant: UIScreen.width - 48),
            mapView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -50),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        postProfile.setLayout()
    }
}

// MARK: - Methods

private extension ReadViewController {
    func navigateToProfileView(_ userId: String) {
        let provider = APIProvider(session: URLSession.shared)
        let searchUseCase = Searcher(provider: provider)
        let followFeature = FollowFeature(provider: provider)
        let userInfoViewModel = UserInfoViewModel(postSearcher: searchUseCase, followFeature: followFeature, patcher: Patcher(provider: provider))
        let userInfoViewController = UserInfoViewController(viewModel: userInfoViewModel, userInfo: userId)

        navigationController?.pushViewController(userInfoViewController, animated: true)
    }
    
    func updatePost(_ readPost: ReadPost) {
        self.readPost = readPost
        
        likeButton.setTitle("\(readPost.likeNum)", for: .normal)
        
        viewButton.setTitle("\(readPost.viewNum)", for: .normal)
        
        postProfile.updateProfil(readPost.writer)

        titleLabel.text = readPost.title
        imageDescriptionLabel.text = readPost.contents.first?.description
        
        let imageURLs = readPost.contents.compactMap { $0.imageURL }
        downloadImages(imageURLs: imageURLs) { [weak self] images in
            self?.carouselView.updateData(images)
        }
    }
    
    func downloadImages(imageURLs: [String], completion: @escaping ([UIImage]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var images = [UIImage]()
        
        imageURLs.forEach {
            dispatchGroup.enter()
            
            if let url = URL(string: $0) {
                URLSession.shared.dataTask(with: url) { (data, _, _) in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        images.append(image)
                    } else {
                        debugPrint("Failed to download image form \(url)")
                    }
                }.resume()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }
    
}

// TODO: - 정리
private extension ReadViewController {
    enum Metrics {
        static let profileImageViewWidth: CGFloat = 36
        static let profileImageViewHeight: CGFloat = 36
        static let viewImageViewWidth: CGFloat = 16
        static let viewImageViewHeight: CGFloat = 16
        static let likeImageViewWidth: CGFloat = 16
        static let likeImageViewHieght: CGFloat = 16
    }

    enum Padding {
        static let profileImageViewLeading: CGFloat = 10
        static let userNameLabelLeading: CGFloat = 10
        static let viewCountLabelTrailing: CGFloat = -10
        static let viewImageViewTrailing: CGFloat = -10
        static let likeCountLabelTrailing: CGFloat = -20
        static let likeImageViewTrailing: CGFloat = -10
    }
}
