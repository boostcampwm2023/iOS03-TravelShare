//
//  SearchViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Combine
import MacroNetwork
import UIKit

final class SearchViewController: TouchableViewController {

    // MARK: - Properties
    
    let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject: PassthroughSubject<SearchViewModel.Input, Never> = .init()
    let postCollectionViewModel = PostCollectionViewModel(followFeature: FollowFeature(provider: APIProvider(session: URLSession.shared)), patcher: Patcher(provider: APIProvider(session: URLSession.shared)), postSearcher: Searcher(provider: APIProvider(session: URLSession.shared)), sceneType: .searchPostTitle)
    private var tabBarOutputSubject: PassthroughSubject<TabBarViewModel.Output, Never>
    
    // MARK: - UI Components
    
    private let searchBar: UITextField = CommonUIComponents.createSearchBar()
    
    lazy var postCollectionView: PostCollectionView = {
        let collectionView = PostCollectionView(frame: .zero, viewModel: postCollectionViewModel)
        collectionView.isHidden = true
        return collectionView
    }()
    
    lazy var userResultCollectionView: UserResultCollectionView = {
        let collectionView = UserResultCollectionView(frame: .zero, viewModel: viewModel)
        collectionView.backgroundColor = UIColor.appColor(.blue1)
        return collectionView
    }()
    
    private let searchSegment: UISegmentedControl = {
        let segmentItems = ["계정", "글"]
        let segmentControl = UISegmentedControl(items: segmentItems)
        segmentControl.selectedSegmentIndex = 0
        let accountImage = UIImage.appImage(.person2Fill) ?? UIImage()
        let postImage = UIImage.appImage(.chartBarDocHorizontal) ?? UIImage()
        let font = UIFont.appFont(.baeEunBody)
        let color = UIColor.appColor(.purple5)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor: color
        ]
        for (index, text) in segmentItems.enumerated() {
            let icon = index == 0 ? accountImage : postImage
            let textSize = (text as NSString).size(withAttributes: attributes)
            let textRect = CGRect(origin: CGPoint.zero, size: textSize)
            let iconRect = CGRect(origin: CGPoint(x: textRect.maxX + 5, y: (textSize.height - icon.size.height) / 2), size: icon.size)
            let imageSize = CGSize(width: iconRect.maxX, height: max(textRect.height, icon.size.height))
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            text.draw(in: textRect, withAttributes: attributes)
            icon.draw(in: iconRect)
            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            segmentControl.setImage(combinedImage, forSegmentAt: index)
        }
        return segmentControl
    }()
    
    // MARK: - Life Cycle
        override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        bind()
        postCollectionView.postDelegate = self
        userResultCollectionView.postDelegate = self
        searchSegment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        searchBar.addTarget(self, action: #selector(searchBarReturnPressed), for: .editingDidEndOnExit)
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: Init
    init(viewModel: SearchViewModel, tabBarOutputSubject: PassthroughSubject<TabBarViewModel.Output, Never>) {
        self.viewModel = viewModel
        self.tabBarOutputSubject = tabBarOutputSubject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings

extension SearchViewController {
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchSegment.translatesAutoresizingMaskIntoConstraints = false
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        userResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        view.addSubview(searchBar)
        view.addSubview(searchSegment)
        view.addSubview(postCollectionView)
        view.addSubview(userResultCollectionView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.segmentTop),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.searchSide),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.searchSide),
            searchBar.heightAnchor.constraint(equalToConstant: Metrics.searchBarHeight),
            searchSegment.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Padding.segmentTop),
            searchSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchSegment.heightAnchor.constraint(equalToConstant: Metrics.segmentHeight),
            searchSegment.widthAnchor.constraint(equalToConstant: Metrics.segmentWidth),
            postCollectionView.topAnchor.constraint(equalTo: searchSegment.bottomAnchor, constant: Padding.postCollectionViewTop),
            postCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            postCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            postCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            userResultCollectionView.topAnchor.constraint(equalTo: searchSegment.bottomAnchor, constant: Padding.postCollectionViewTop),
            userResultCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            userResultCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            userResultCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Bind
extension SearchViewController {
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .updatePostSearchResult(result):
                self?.updatePostSearchResult(result)
            case let .updateUserSearchResult(result):
                self?.updateUserSearchResult(result)
            case let .transView(destinationViewType):
                self?.transView(destinationViewType)
            }
        }.store(in: &cancellables)
        
    }
}

// MARK: - Methods
extension SearchViewController {
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        
        let selectedType = sender.selectedSegmentIndex == 0 ? SearchType.account : SearchType.post
        
        postCollectionView.isHidden = selectedType != .post
        userResultCollectionView.isHidden = selectedType != .account
        inputSubject.send(.changeSelectType(selectedType))
    }
    
    @objc private func searchBarReturnPressed() {
        let text = searchBar.text ?? ""
        postCollectionViewModel.query = text
        inputSubject.send(.search(text))
    }
    
    func updatePostSearchResult(_ result: [PostFindResponse]) {
        postCollectionView.viewModel.posts = result
        postCollectionView.reloadData()
    }
    
    func updateUserSearchResult(_ result: [UserProfile]) {
        userResultCollectionView.reloadData()
    }
    
    func transView(_ changeTabbarType: TabbarType) {
        tabBarOutputSubject.send(.changeTap(changeTabbarType))
    }
}

// MARK: - LayoutMetrics
extension SearchViewController {
    enum Metrics {
        static let searchBarHeight: CGFloat = 43
        static let segmentHeight: CGFloat = 34
        static let segmentWidth: CGFloat = 222
    }
    
    enum Padding {
        static let seachBarTop: CGFloat = 10
        static let segmentTop: CGFloat = 20
        static let searchSide: CGFloat = 10
        static let postCollectionViewTop: CGFloat = 20
    }
}
