//
//  UserAgreementTapView.swift
//  Macro
//
//  Created by Byeon jinha on 12/13/23.
//

import Combine
import UIKit

final class UserAgreementTapView: UIView {
    
    // MARK: - Properties
    var url: URL?
    var agreement: UserAgreementModel
    var viewModel: UserAgreementViewModel
    private let inputSubject: PassthroughSubject<UserAgreementViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.appImage(.checkmarkCircle))
        imageView.tintColor = UIColor.appColor(.purple2)
        return imageView
    }()
    
    let checkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunCallout)
        label.textColor = UIColor.appColor(.purple3)
        return label
    }()
    
    let showDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "자세히 보기"
        label.font = UIFont.appFont(.baeEunCaption)
        label.textColor = UIColor.appColor(.purple2)
        return label
    }()

    init(agreement: UserAgreementModel, viewModel: UserAgreementViewModel) {
        self.agreement = agreement
        self.viewModel = viewModel
        super.init(frame: .zero)
        checkLabel.text = agreement.content
        url = agreement.url
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserAgreementTapView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkLabel.translatesAutoresizingMaskIntoConstraints = false
        showDetailLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.addSubview(checkImageView)
        self.addSubview(checkLabel)
        self.addSubview(showDetailLabel)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            checkImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            checkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            checkLabel.leadingAnchor.constraint(equalTo: checkImageView.trailingAnchor, constant: 10),
            checkLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            showDetailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            showDetailLabel.widthAnchor.constraint(equalToConstant: 60),
            showDetailLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Bind
private extension UserAgreementTapView {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            default: break
            }
        }.store(in: &cancellables)
    }
}

// MARK: - Methods

extension UserAgreementTapView {
    
    func configure() {
        setupLayout()
        addTapGesture()

        checkImageView.isUserInteractionEnabled = true
        checkLabel.isUserInteractionEnabled = true
        showDetailLabel.isUserInteractionEnabled = true
        if url == nil {
            self.backgroundColor = UIColor.appColor(.purple1)
            self.layer.cornerRadius = 10
            self.showDetailLabel.isHidden = true
        }
    }
    
    func updateCheck(isCheck: Bool) {
        checkImageView.image = isCheck ? UIImage.appImage(.checkmarkCircleFill) : UIImage.appImage(.checkmarkCircle)
        checkImageView.tintColor = isCheck ? UIColor.appColor(.purple3) : UIColor.appColor(.purple2)
    }
    
    @objc private func showDetailTapped(_ sender: UITapGestureRecognizer) {
        guard let url = url else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func checkImageViewTapped(_ sender: UITapGestureRecognizer) {
        inputSubject.send(.touchAgree(agreement.type))
    }
    
    func addTapGesture() {
        let showDetailLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(showDetailTapped(_:)))
        showDetailLabel.addGestureRecognizer(showDetailLabelTapGesture)
        
        let checkImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(checkImageViewTapped))
        checkImageView.addGestureRecognizer(checkImageViewTapGesture)
        
        let checkLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(checkImageViewTapped))
        checkLabel.addGestureRecognizer(checkLabelTapGesture)
    }
}
