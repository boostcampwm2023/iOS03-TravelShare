//
//  HomeHeaderView.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import UIKit

final class HomeHeaderView: UIView {
    
    // MARK: - UI Components
    let logoImageView: UIImageView = {
        let logoImage = UIImage.appImage(.appLogo)
        let imageView: UIImageView = UIImageView()
        imageView.image = logoImage
        return imageView
    }()
   
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = LabelContents.titleText
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.textColor = UIColor.appColor(.blue2)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: UI Settings

extension HomeHeaderView {
    
    private func setupTranslatesAutoresizingMaskIntoConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        self.addSubview(logoImageView)
        self.addSubview(titleLabel)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: Metrics.logoImageViewHeight),
            logoImageView.widthAnchor.constraint(equalToConstant: CGFloat(Metrics.logoImageViewWidth)),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Padding.logoImageViewLeading),

            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setUpLayout() {
        setupTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - LayoutMetrics

private extension HomeHeaderView {
    
    enum Metrics {
        static let logoImageViewWidth: CGFloat = 40
        static let logoImageViewHeight: CGFloat = 40
    }
    
    enum LabelContents {
        static let titleText: String = "어디갈래?"
    }
    
    enum Padding {
        static let logoImageViewLeading: CGFloat = 30
    }
}
