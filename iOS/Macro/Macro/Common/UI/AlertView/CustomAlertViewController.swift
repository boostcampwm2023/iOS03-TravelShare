//
//  CustomAlertViewController.swift
//  Macro
//
//  Created by Byeon jinha on 12/6/23.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var alertTitle: String?
    var message: String?
    var addActionConfirm: AddAction?
    var addActionCancel: AddAction?
    
    // MARK: -
    private lazy var alertView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.appColor(.purple2)
        return view
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunTitle1)
        label.textColor = UIColor.appColor(.blue1)
        label.textAlignment = .center
        label.text = alertTitle
        return label
    }()
    
    private lazy var messageLabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunCallout)
        label.textColor = UIColor.appColor(.blue1)
        label.textAlignment = .center
        label.text = message
        return label
    }()
    
    private lazy var horizontalDividerView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(.blue1)
        return view
    }()
    
    private lazy var confirmButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.appFont(.baeEunCallout)
        button.setTitle(addActionConfirm?.text, for: .normal)
        button.setTitleColor(UIColor.appColor(.statusGreen), for: .normal)
        button.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(UIColor.appColor(.statusRed), for: .normal)
        button.titleLabel?.font = UIFont.appFont(.baeEunCallout)
        button.setTitle(addActionCancel?.text, for: .normal)
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func confirmPressed() {
        addActionConfirm?.action?()
        dismiss(animated: true)
    }
    
    @objc func cancelPressed() {
        addActionCancel?.action?()
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.appColor(.opacity30)
        setupLayout()
    }
}

// MARK: - UI Settings

private extension CustomAlertViewController {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        alertView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalDividerView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        view.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(horizontalDividerView)
        alertView.addSubview(confirmButton)
        alertView.addSubview(cancelButton)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            alertView.widthAnchor.constraint(equalToConstant: 300),
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            titleLabel.widthAnchor.constraint(equalToConstant: 260),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 30),
            
            messageLabel.widthAnchor.constraint(equalToConstant: 260),
            messageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            horizontalDividerView.widthAnchor.constraint(equalToConstant: 260),
            horizontalDividerView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            horizontalDividerView.heightAnchor.constraint(equalToConstant: 1),
            horizontalDividerView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.topAnchor.constraint(equalTo: horizontalDividerView.bottomAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            
            confirmButton.widthAnchor.constraint(equalToConstant: 150),
            confirmButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.topAnchor.constraint(equalTo: horizontalDividerView.bottomAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor)
        ])
    }
    
    func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}
