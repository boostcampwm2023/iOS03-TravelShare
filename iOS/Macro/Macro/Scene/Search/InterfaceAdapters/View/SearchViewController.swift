//
//  SearchViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import UIKit
import Combine

final class SearchViewController: TabViewController {
    
    // MARK: - Properties
    
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject: PassthroughSubject<SearchViewModel.Input, Never> = .init()
    private let homeHeaderView: HomeHeaderView = HomeHeaderView()
    lazy var searchCollectionView: HomeCollectionView = HomeCollectionView(frame: .zero, collectionViewLayout: homeCollectionViewLayout)
    
    // MARK: - UI Components
    
    private let searchBar: UITextField = CommonUIComponents.createSearchBar()
    
    private let searchSegment: UISegmentedControl = {
        let segmentItems = ["계정", "글"]
        let segmentControl = UISegmentedControl(items: segmentItems)
        segmentControl.selectedSegmentIndex = 0
        let accountImage = UIImage.appImage(.person2Fill) ?? UIImage()
        let postImage = UIImage.appImage(.chartBarDocHorizontal) ?? UIImage()
        let fontSize: CGFloat = 16
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        
        for (index, text) in segmentItems.enumerated() {
            let icon = index == 0 ? accountImage : postImage
            let textSize = (text as NSString).size(withAttributes: attributes)
            let textRect = CGRect(origin: CGPoint.zero, size: textSize)
            let iconRect = CGRect(origin: CGPoint(x: textRect.maxX + 5, y: 0), size: icon.size)
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
    
    private var homeCollectionViewLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpLayout()
        bind()
        searchSegment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        searchBar.addTarget(self, action: #selector(searchBarReturnPressed), for: .editingDidEndOnExit)
    }
    
    // MARK: - Init
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings
extension SearchViewController {
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchSegment.translatesAutoresizingMaskIntoConstraints = false
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        view.addSubview(searchBar)
        view.addSubview(searchSegment)
        view.addSubview(searchCollectionView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchSegment.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            searchSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchSegment.heightAnchor.constraint(equalToConstant: 40),
            searchCollectionView.topAnchor.constraint(equalTo: searchSegment.bottomAnchor, constant: Padding.homeCollectionViewTop),
            searchCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
}

extension SearchViewController {
    
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
            case let .updateSearchResult(result):
                self?.updateSearchResult(result)
            }
        }.store(in: &cancellables)
        
    }
}

// MARK: - Methods
extension SearchViewController {
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        let selectedType = sender.selectedSegmentIndex == 0 ? SearchType.account : SearchType.post
        inputSubject.send(.changeSelectType(selectedType))
    }
    
    @objc private func searchBarReturnPressed() {
        let text = searchBar.text ?? ""
        inputSubject.send(.search(text))
    }
    
    func updateSearchResult(_ result: [PostFindResponse]) {
        searchCollectionView.posts = result
        searchCollectionView.reloadData()
    }
}

// MARK: - LayoutMetrics
extension SearchViewController {
    enum Metrics {
        static let homeHeaderViewHeight: CGFloat = 60
    }
    
    enum Padding {
        static let homeHeaderViewTop: CGFloat = 50
        static let homeCollectionViewTop: CGFloat = 10
    }
}
