//
//  UserAgreementHeaderView.swift
//  Macro
//
//  Created by Byeon jinha on 12/13/23.
//

import UIKit

final class UserAgreementHeaderView: UIView {
    
    // MARK: - UI Components
    
    let appLogoImageView: UIImageView = UIImageView(image: UIImage.appImage(.appLogo))
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어디갈래 서비스 이용약관 동의"
        label.font = UIFont.appFont(.baeEunTitle1)
        label.textColor = UIColor.appColor(.purple4)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension UserAgreementHeaderView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.addSubview(appLogoImageView)
        self.addSubview(titleLabel)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            appLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            appLogoImageView.widthAnchor.constraint(equalToConstant: 40),
            appLogoImageView.heightAnchor.constraint(equalToConstant: 40),
            appLogoImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -20)
        ])
    }
    
    func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}
