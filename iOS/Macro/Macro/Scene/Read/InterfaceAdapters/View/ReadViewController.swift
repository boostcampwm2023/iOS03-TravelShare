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
    private var readPost: ReadPost?
    private var cancellables = Set<AnyCancellable>()
    private let didScrollSubject: PassthroughSubject<Int, Never> = .init()
    private let inputSubject: PassthroughSubject<ReadViewModel.Input, Never> = .init()
    private var routeOverlay: NMFPath?
    
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
    
    private lazy var carouselView: MacroCarouselView = MacroCarouselView(
        didScrollOutputSubject: didScrollSubject,
        inputSubject: inputSubject,
        viewModel: viewModel)
    
    private let likeImageView: UIImageView = {
        let image: UIImage? = UIImage.appImage(.handThumbsup)
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        imageView.tintColor = UIColor.appColor(.purple5)
        return imageView
    }()
    
    private let likeCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let viewImageView: UIImageView = {
        let image: UIImage? = UIImage.appImage(.eyes)
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        imageView.tintColor = UIColor.appColor(.purple5)
        return imageView
    }()
    
    private let viewCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.positionMode = .normal
        mapView.layer.cornerRadius = 20
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.appColor(.purple1).cgColor
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
    
    // MARK: - Handle Gesture
    
    @objc private func likeImageViewTap(_ sender: UITapGestureRecognizer) {
        likeImageView.isUserInteractionEnabled = false
        inputSubject.send(.likeImageTap)
    }
}

// MARK: - UI Settings

private extension ReadViewController {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        postProfile.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        viewImageView.translatesAutoresizingMaskIntoConstraints = false
        viewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollContentView)
        [
            postProfile,
            titleLabel,
            carouselView,
            likeImageView,
            likeCountLabel,
            viewImageView,
            viewCountLabel,
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
            carouselView.heightAnchor.constraint(equalToConstant: 400),
            carouselView.widthAnchor.constraint(equalToConstant: UIScreen.width),
            
            likeImageView.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 40),
            likeImageView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            
            likeCountLabel.centerYAnchor.constraint(equalTo: likeImageView.centerYAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeImageView.trailingAnchor, constant: 10),
            
            viewImageView.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 40),
            viewImageView.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 10),
            
            viewCountLabel.centerYAnchor.constraint(equalTo: viewImageView.centerYAnchor),
            viewCountLabel.leadingAnchor.constraint(equalTo: viewImageView.trailingAnchor, constant: 10),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            mapView.topAnchor.constraint(equalTo: likeImageView.bottomAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            mapView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
            mapView.heightAnchor.constraint(equalToConstant: UIScreen.width - 48),
            mapView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -50)
        ])
    }
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        postProfile.setLayout()
        addTapGesture()
    }
    
    func addTapGesture() {
        likeImageView.isUserInteractionEnabled = true
        let likeImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(likeImageViewTap(_:)))
        likeImageView.addGestureRecognizer(likeImageViewTapGesture)
    }
}

// MARK: - Bind

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
                case let .updatePageIndex(index):
                    self?.updatePageIndex(index)
                case let .updatePostLike(likePostResponse):
                    self?.likeCountLabel.text = "\(likePostResponse.likeNum)"
                    self?.likeImageView.image = likePostResponse.liked ? UIImage.appImage(.handThumbsupFill) : UIImage.appImage(.handThumbsup)
                    self?.likeImageView.tintColor = likePostResponse.liked ? UIColor.appColor(.purple2) : UIColor.appColor(.purple5)
                    self?.likeImageView.isUserInteractionEnabled = true
                }
            }
            .store(in: &cancellables)
        
        didScrollSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] index in
                self?.carouselView.descriptionLabel.text = self?.readPost?.contents[index].description
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

private extension ReadViewController {
    
    func updatePageIndex(_ index: Int) {
        self.carouselView.pageController.currentPage = viewModel.pageIndex
        self.didScrollSubject.send(viewModel.pageIndex)
    }
    
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
        
        likeCountLabel.text = "\(readPost.likeNum)"
        
        viewCountLabel.text = "\(readPost.viewNum)"
        
        postProfile.updateProfil(readPost.writer)
        
        titleLabel.text = readPost.title
        
        carouselView.descriptionLabel.text = readPost.contents.first?.description
        
        let imageURLs = readPost.contents.compactMap { $0.imageURL }
        downloadImages(imageURLs: imageURLs) { [weak self] images in
            self?.carouselView.updateData(images)
        }
        
        self.likeImageView.image = readPost.liked ? UIImage.appImage(.handThumbsupFill) : UIImage.appImage(.handThumbsup)
        self.likeImageView.tintColor = readPost.liked ? UIColor.appColor(.purple2) : UIColor.appColor(.purple5)
        
        calculateCenterLocation(routePoints: readPost.route.coordinates)
        updateMapWithLocation(routePoints: readPost.route.coordinates )
        
        // TODO: - 핀 로직 수정 후 작업
        updateMark(recordedPindedInfo: readPost.pins)
    }
    
    func downloadImages(imageURLs: [String], completion: @escaping ([UIImage?]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var images: [UIImage?] = Array(repeating: nil, count: imageURLs.count)
        
        imageURLs.enumerated().forEach { index, imageURL in
            dispatchGroup.enter()
            
            guard let url = URL(string: imageURL) else { return }
            if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
                let image = UIImage(data: cachedResponse.data)
                DispatchQueue.main.async {
                    images[index] = image
                }
                
            } else {
                URLSession.shared.dataTask(with: url) { (data, response, _) in
                    defer {
                        dispatchGroup.leave()
                    }
                    if let data = data, let image = UIImage(data: data) {
                        let cachedResponse = CachedURLResponse(response: response!, data: data)
                                           URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                        DispatchQueue.main.async {
                            images[index] = image
                        }
                    } else {
                        images[index] = UIImage.appImage(.ProfileDefaultImage)
                    }
                }.resume()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }
    
    func calculateCenterLocation(routePoints: [Coordinate]) {
        var maxLatitude = -90.0
        var minLatitude = 90.0
        var maxLongitude = -180.0
        var minLongitude = 180.0
        
        for point in routePoints {
            let latitude = point.yPosition
            let longitude = point.xPosition
            
            if latitude > maxLatitude {
                maxLatitude = latitude
            }
            if latitude < minLatitude {
                minLatitude = latitude
            }
            if longitude > maxLongitude {
                maxLongitude = longitude
            }
            if longitude < minLongitude {
                minLongitude = longitude
            }
        }
        
        let centerLatitude = (maxLatitude + minLatitude) / 2.0
        let centerLongitude = (maxLongitude + minLongitude) / 2.0
        
        let centerLocation = NMGLatLng(lat: centerLatitude, lng: centerLongitude)
        let distanceLatitude = abs(maxLatitude - minLatitude)
        let distanceLongitude = abs(maxLongitude - minLongitude)
        
        let zoomLevelLatitude = log2(90 / distanceLatitude)
        let zoomLevelLongitude = log2(90 / distanceLongitude)
        let zoomLevel = min(zoomLevelLatitude, zoomLevelLongitude)
        mapView.zoomLevel = zoomLevel
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: centerLocation )
        mapView.moveCamera(cameraUpdate)
    }
    
    /// 이동 경로를 입력받아 지도에 그립니다.
    /// - Parameters:
    ///   - routePoints: 위도, 경도 배열 입니다.
    func updateMapWithLocation(routePoints: [Coordinate]) {
        routeOverlay?.mapView = nil
        let coords = routePoints.map { NMGLatLng(lat: $0.yPosition, lng: $0.xPosition) }
        routeOverlay = NMFPath(points: coords)
        routeOverlay?.color = UIColor.appColor(.purple1)
        routeOverlay?.mapView = mapView
    }
    
    // TODO: - 위경도 좌표가 바뀌어 있어요. 다음 스프린트 때, 코어데이터 테이블 추가하면서 수정하도록하겠습니다. :)
    /// Pin이 저장된 곳에  Mark를 찍습니다.
    /// - Parameters:
    ///   - recordedPindedInfo: Pin의 위도, 경도 배열 입니다.
    func updateMark(recordedPindedInfo: [Pin]) {
        for (index, placeInfo) in recordedPindedInfo.enumerated() {
            let marker = NMFMarker()
            let name = placeInfo.placeName
            let placeLocation = placeInfo.coordinate
            marker.position = NMGLatLng(lat: placeLocation.yPosition, lng: placeLocation.xPosition)
            marker.captionText = "\(index + 1). \(name)"
            marker.mapView = mapView
        }
    }
}

// MARK: - LayoutMetrics
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
