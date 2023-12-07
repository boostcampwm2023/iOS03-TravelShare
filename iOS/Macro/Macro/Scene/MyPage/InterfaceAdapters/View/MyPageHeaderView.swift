//
//  MyPageHeaderView.swift
//  Macro
//
//  Created by Byeon jinha on 11/30/23.
//

import UIKit

final class MyPageHeaderView: UIView {
    
    // MARK: - UIComponents
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunLargeTitle)
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: UI Settings

private extension MyPageHeaderView {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.imageWidth),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.imageHeight),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: Padding.labelTop),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - Methods

extension MyPageHeaderView {
    
    func configure(userProfile: UserProfile) { 
        if let url = userProfile.imageUrl {
            loadImage(profileImageStringURL: url) { image in
                DispatchQueue.main.async { [self] in
                    if let image = image {
                        profileImageView.image = image
                    } else {
                        let defaultImage = UIImage.appImage(.ProfileDefaultImage)
                        profileImageView.image = defaultImage
                    }
                }
            }
        } else {
            profileImageView.image = UIImage.appImage(.personCircle)
            profileImageView.tintColor = UIColor.appColor(.purple2)
            profileImageView.backgroundColor = UIColor.appColor(.purple1)
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        nameLabel.text = userProfile.name
    }
    
    func configure(profileImage: UIImage) {
        profileImageView.image = profileImage
    }
    
    func loadImage(profileImageStringURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: profileImageStringURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

// MARK: - LayoutMetrics

extension MyPageHeaderView {
    enum Metrics {
        static let imageWidth: CGFloat = 120
        static let imageHeight: CGFloat = 120
        static let nameLabelWidth: CGFloat = 100
        static let nameLabelHeight: CGFloat = 46
    }
    enum Padding {
        static let imageTop: CGFloat = 40
        static let labelTop: CGFloat = 20
    }
}
