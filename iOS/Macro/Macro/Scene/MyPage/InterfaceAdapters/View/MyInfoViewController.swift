//
//  MyInformationViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/27/23.
//

import UIKit

final class MyInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: MyPageViewModel
    let selectedIndex: Int

    // MARK: - UI Components
    
    lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.text = viewModel.information[selectedIndex]
        return label
    }()

    private lazy var nameEditView: NameEditView = {
        let view = NameEditView()
        view.optionLabel.text = viewModel.information[selectedIndex]
        return view
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }

    // MARK: - Init
    
    init(viewModel: MyPageViewModel, selectedIndex: Int) {
        self.viewModel = viewModel
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Settings
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        nameEditView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addSubviews() {
        view.addSubview(guideLabel)
        if selectedIndex == 0 {
            view.addSubview(nameEditView)
        }
    }

    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.labelTop),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide)
        ])

        if selectedIndex == 0 {
            NSLayoutConstraint.activate([
                nameEditView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: Padding.nameViewTop),
                nameEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.nameViewSide),
                nameEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.nameViewSide),
                nameEditView.heightAnchor.constraint(equalToConstant: Metrics.nameViewHeight)
            ])
        }
    }

    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }

    // MARK: - Binding
    
    private func bind() {
     
    }

    // MARK: - Methods
    
}

// MARK: - LayoutMetrics

extension MyInfoViewController {
    enum Metrics {
        static let nameViewHeight: CGFloat = 80
    }

    enum Padding {
        static let labelTop: CGFloat = 94
        static let labelSide: CGFloat = 40
        static let nameViewTop: CGFloat = 10
        static let nameViewSide: CGFloat = 38
    }
}
