//
//  MyInformationViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/27/23.
//

import Combine
import UIKit

final class MyInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: MyPageViewModel
    let selectedIndex: Int
    private let inputSubject: PassthroughSubject<MyPageViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
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
        view.nameTextField.text = viewModel.myInfo.name
        return view
    }()
    
    private lazy var introductionEditView: IntroductionEditView = {
        let view = IntroductionEditView()
        view.optionLabel.text = viewModel.information[selectedIndex]
        view.introductionTextView.text = viewModel.myInfo.introduce
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.appColor(.purple2)
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor.appColor(.blue1), for: .normal)
        button.titleLabel?.font = UIFont.appFont(.baeEunTitle1)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        introductionEditView.introductionTextView.delegate = self
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
        introductionEditView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        view.addSubview(guideLabel)
        view.addSubview(saveButton)
        if selectedIndex == 0 {
            view.addSubview(nameEditView)
        }
        else if selectedIndex == 2 {
            view.addSubview(introductionEditView)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.labelTop),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Padding.saveButtonBottom),
            saveButton.widthAnchor.constraint(equalToConstant: Metrics.saveButtonWidth),
            saveButton.heightAnchor.constraint(equalToConstant: Metrics.saveButtonHeight)
        ])
        
        if selectedIndex == 0 {
            NSLayoutConstraint.activate([
                nameEditView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: Padding.nameViewTop),
                nameEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.nameViewSide),
                nameEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.nameViewSide),
                nameEditView.heightAnchor.constraint(equalToConstant: Metrics.nameViewHeight)
            ])
        }
        else if selectedIndex == 2 {
            NSLayoutConstraint.activate([
                introductionEditView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: Padding.nameViewTop),
                introductionEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.nameViewSide),
                introductionEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.nameViewSide),
                introductionEditView.heightAnchor.constraint(equalToConstant: Metrics.introductionViewHeight)
            ])
        }
        
    }
    
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
    // MARK: - Binding
    
    
    
    @objc private func saveButtonTapped() {
        switch selectedIndex {
        case 0: inputSubject.send(.completeButtonPressed(selectedIndex, nameEditView.nameTextField.text ?? ""))
        default: inputSubject.send(.completeButtonPressed(selectedIndex, introductionEditView.introductionTextView.text ?? ""))
        }
    }
    
}

// MARK: - Methods

extension MyInfoViewController: UITextViewDelegate {
    // TODO: - TextView 3줄 제한
    func textViewDidChange(_ textView: UITextView) {
        
    }
}
// MARK: - LayoutMetrics

extension MyInfoViewController {
    enum Metrics {
        static let nameViewHeight: CGFloat = 80
        static let introductionViewHeight: CGFloat = 150
        static let saveButtonHeight: CGFloat = 40
        static let saveButtonWidth: CGFloat = 300
    }
    
    enum Padding {
        static let labelTop: CGFloat = 94
        static let labelSide: CGFloat = 40
        static let nameViewTop: CGFloat = 10
        static let nameViewSide: CGFloat = 38
        static let saveButtonBottom: CGFloat = 40
    }
}
