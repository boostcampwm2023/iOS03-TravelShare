//
//  FollowViewController.swift
//  Macro
//
//  Created by 김나훈 on 12/5/23.
//

import Combine
import UIKit

final class FollowViewController: TouchableViewController {
    
    // MARK: - Properties
    
    let viewModel: MyPageViewModel
    private let inputSubject: PassthroughSubject<MyPageViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.textColor = UIColor.appColor(.purple5)
        return label
    }()

    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["팔로워", "팔로잉"])
        control.selectedSegmentIndex = 0
        control.tintColor = UIColor.appColor(.purple2)
        let font = UIFont.appFont(.baeEunBody)
        let normalTextColor = UIColor.appColor(.purple5)
        control.setTitleTextAttributes([.font: font ?? UIFont.systemFont(ofSize: 12), .foregroundColor: normalTextColor], for: .normal)
        return control
    }()
    
    lazy var followResultCollectionView: FollowResultCollectionView = {
        let collectionView = FollowResultCollectionView(frame: .zero, viewModel: viewModel)
        return collectionView
    }()
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        bind()
        inputSubject.send(.getFollowInformation)
        segmentControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        followResultCollectionView.postDelegate = self
    }
    
    // MARK: - Init
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

extension FollowViewController {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        followResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(segmentControl)
        view.addSubview(followResultCollectionView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.labelTop),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: Metrics.labelHeight),
            segmentControl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Padding.segmentTop),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalToConstant: 250),
            followResultCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Padding.collectionViewTop),
            followResultCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            followResultCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            followResultCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
    
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
}
// MARK: - Bind

extension FollowViewController {
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .sendFolloweesCount(count):
                self?.updateFolloweesCount(count)
            case let .sendFollowersCount(count):
                self?.updateFollowersCount(count)
            case .reloadData:
                self?.reloadData()
            default: break
            }
        }.store(in: &cancellables)
    }
    
}

// MARK: - Methods

extension FollowViewController {
    
    private func updateFolloweesCount(_ count: Int) {
        segmentControl.setTitle("\(count) 팔로잉", forSegmentAt: 1)
    }
    
    private func updateFollowersCount(_ count: Int) {
        segmentControl.setTitle("\(count) 팔로워", forSegmentAt: 0)
    }
    
    private func reloadData() {
        followResultCollectionView.reloadData()
    }
    
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        inputSubject.send(.getFollowInformation)
    }
}

// MARK: - LayoutMetrics

extension FollowViewController {
    enum Metrics {
        static let labelHeight: CGFloat = 46
    }
    
    enum Padding {
        static let labelTop: CGFloat = 20
        static let segmentTop: CGFloat = 10
        static let collectionViewTop: CGFloat = 20
    }
}
