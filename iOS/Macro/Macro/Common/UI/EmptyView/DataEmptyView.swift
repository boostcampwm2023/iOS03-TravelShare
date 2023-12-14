//
//  DataEmptyView.swift
//  Macro
//
//  Created by Byeon jinha on 12/10/23.
//

import UIKit

class DataEmptyView: UIView {
    
    // MARK: - Properties
    
    var emptyTitle: String?
    var addActionConfirm: ConfirmAction?
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunTitle1)
        label.textColor = UIColor.appColor(.purple4)
        label.textAlignment = .center
        label.text = emptyTitle
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage.appImage(.emptyImage)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.appColor(.purple2)
        button.layer.cornerRadius = 10
        button.setTitle(addActionConfirm?.text, for: .normal)
        button.setTitleColor(UIColor.appColor(.blue1), for: .normal)
        button.titleLabel?.font = UIFont.appFont(.baeEunTitle1)
        button.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func confirmPressed() {
        addActionConfirm?.action?()
    }
    
    init(emptyTitle: String? = nil, addActionConfirm: ConfirmAction? = nil) {
        self.emptyTitle = emptyTitle
        self.addActionConfirm = addActionConfirm
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

private extension DataEmptyView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.addSubview(titleLabel)
        self.addSubview(imageView)
        self.addSubview(confirmButton)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            confirmButton.widthAnchor.constraint(equalToConstant: addActionConfirm == nil ? 0 : 300),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            confirmButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            confirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}
