//
//  FollowViewController.swift
//  Macro
//
//  Created by 김나훈 on 12/5/23.
//

import Combine
import UIKit

final class FollowViewController: UIViewController {
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        bind()
        inputSubject.send(.getFollowInformation)
        segmentControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
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
    }
    
    private func addSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(segmentControl)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.labelTop),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: Metrics.labelHeight),
            segmentControl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Padding.segmentTop),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
            case let .sendFollowResult(response): break
            default: break
            }
        }.store(in: &cancellables)
    }
    
}

// MARK: - Methods

extension FollowViewController {
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
    }
}
