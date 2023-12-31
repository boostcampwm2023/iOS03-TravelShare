//
//  LocationInfoViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import Combine
import MacroDesignSystem
import MacroNetwork
import UIKit

final class LocationInfoViewController: TouchableViewController {
    
    // MARK: - Properties
    
    let viewModel: LocationInfoViewModel
    let postCollectionViewModel = PostCollectionViewModel(followFeature: FollowFeature(provider: APIProvider(session: URLSession.shared)), patcher: Patcher(provider: APIProvider(session: URLSession.shared)), postSearcher: Searcher(provider: APIProvider(session: URLSession.shared)), sceneType: .relatedPost)
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject: PassthroughSubject<LocationInfoViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.textColor = UIColor.appColor(.blue4)
        return label
    }()
    
    private let pinImage: UIImageView = {
        let image = UIImage.appImage(.pinFill)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.appColor(.purple4)
        return imageView
    }()
    
    // TODO: 글자 제한 수를 넘을경우 다음 줄로 넘어가게 처리
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.appFont(.baeEunTitle1)
        label.textColor = UIColor.appColor(.blue4)
        return label
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.appFont(.baeEunBody)
        label.textColor = UIColor.appColor(.purple3)
        return label
    }()
    
    private let categoryGroupLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.appFont(.baeEunCaption)
        label.textColor = UIColor.appColor(.purple3)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunCallout)
        label.textColor = UIColor.appColor(.blue4)
        return label
    }()
    
    // MARK: - UI Components
    
    lazy var postCollectionView: PostCollectionView = {
        let collectionView = PostCollectionView(frame: .zero, viewModel: postCollectionViewModel)
        return collectionView
    }()
    
    lazy var relatedLocationCollectionView: RelatedLocationCollectionView = {
        let collectionView = RelatedLocationCollectionView(frame: .zero, viewModel: viewModel)
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["포함된 여행", "함께 많이 간 장소"])
        control.selectedSegmentIndex = 0
        control.tintColor = UIColor.appColor(.purple2)
        let font = UIFont.appFont(.baeEunBody)
        let normalTextColor = UIColor.appColor(.purple5)
        control.setTitleTextAttributes([.font: font ?? UIFont.systemFont(ofSize: 12), .foregroundColor: normalTextColor], for: .normal)
        return control
    }()
    
    lazy var dataEmptyView: DataEmptyView = DataEmptyView(
        emptyTitle: "여행 정보가 없습니다."
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpLayout()
        bind()
        inputSubject.send(.viewDidLoad)
        segmentControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        postCollectionView.postDelegate = self
    }
    
    // MARK: - Init
    
    init(viewModel: LocationInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings

extension LocationInfoViewController {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryGroupLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        relatedLocationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dataEmptyView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        view.addSubview(placeNameLabel)
        view.addSubview(addressLabel)
        view.addSubview(categoryNameLabel)
        view.addSubview(categoryGroupLabel)
        view.addSubview(phoneLabel)
        view.addSubview(pinImage)
        view.addSubview(segmentControl)
        view.addSubview(postCollectionView)
        view.addSubview(relatedLocationCollectionView)
        view.addSubview(dataEmptyView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            placeNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.nameTop),
            placeNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            placeNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: pinImage.leadingAnchor, constant: -10),
            
            addressLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: Padding.addressTop),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
            
            categoryNameLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: Padding.categoryNameTop),
            categoryNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            categoryNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
            
            categoryGroupLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: Padding.categoryGroupTop),
            categoryGroupLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            categoryGroupLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
            
            phoneLabel.topAnchor.constraint(equalTo: categoryGroupLabel.bottomAnchor, constant: Padding.phoneTop),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            phoneLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
            
            pinImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.pinSide),
            pinImage.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor),
            
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: Padding.segmentTop),
           
            postCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Padding.postCollectionViewTop),
            postCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            postCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            postCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            dataEmptyView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Padding.postCollectionViewTop),
            dataEmptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            dataEmptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            dataEmptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            relatedLocationCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Padding.postCollectionViewTop),
            relatedLocationCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            relatedLocationCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            relatedLocationCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
        ])
        
    }
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Bind

extension LocationInfoViewController {
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .changeTextLabel(locationDetail):
                self?.changeTextLabel(locationDetail)
            case let .sendRelatedPost(posts):
                self?.updateRelatedPost(posts)
            case .sendRelatedLocation:
                self?.updateRelatedLocation()
            case let .changePost(isEmpty):
                self?.transViewByPostCount(isEmpty)
            case let .changeRelatePost(isEmpty):
                self?.transViewByRelatePostCount(isEmpty)
            }
        }.store(in: &cancellables)
    }
}

// MARK: - Methods

extension LocationInfoViewController {
    
    private func updateRelatedPost(_ posts: [PostFindResponse]) {
        postCollectionView.viewModel.posts = posts
        postCollectionView.reloadData()
    }
    
    private func updateRelatedLocation() {
        relatedLocationCollectionView.reloadData()
    }
    
    private func transViewByPostCount(_ isEmpty: Bool) {
        dataEmptyView.isHidden = !isEmpty
        postCollectionView.isHidden = isEmpty
    }
    
    private func transViewByRelatePostCount(_ isEmpty: Bool) {
        dataEmptyView.isHidden = !isEmpty
        relatedLocationCollectionView.isHidden = isEmpty
    }
    
    private func changeTextLabel(_ detail: LocationDetail?) {
        guard let locationDetail = detail else { return }
        
        placeNameLabel.text = locationDetail.placeName.isEmpty == true ? "-" : locationDetail.placeName
        addressLabel.text = locationDetail.addressName.isEmpty == true ? "-" : locationDetail.addressName
        categoryNameLabel.text = locationDetail.categoryName.isEmpty == true ? "-" : locationDetail.categoryName
        categoryGroupLabel.text = locationDetail.categoryGroupName.isEmpty == true ? "-" : "(\(locationDetail.categoryGroupName))"
        phoneLabel.text = locationDetail.phone?.isEmpty == true ? "-" : (locationDetail.phone ?? "-")
        
        postCollectionViewModel.query = detail?.id
    }
    
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        let selectedType = sender.selectedSegmentIndex == 0 ? InfoType.post : InfoType.location
        
        postCollectionView.isHidden = selectedType != .post
        relatedLocationCollectionView.isHidden = selectedType != .location
        
        inputSubject.send(.changeSelectType(selectedType))
    }
    
}
// MARK: - LayoutMetrics

extension LocationInfoViewController {
    enum Metrics {
        
    }
    enum Padding {
        static let nameTop: CGFloat = 20
        static let addressTop: CGFloat = 20
        static let categoryNameTop: CGFloat = 10
        static let categoryGroupTop: CGFloat = 0
        static let phoneTop: CGFloat = 10
        static let labelSide: CGFloat = 50
        static let pinSide: CGFloat = 28
        static let segmentTop: CGFloat = 18
        static let postCollectionViewTop: CGFloat = 50
    }
}
