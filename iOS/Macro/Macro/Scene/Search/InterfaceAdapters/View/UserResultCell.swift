//
//  UserResultCell.swift
//  Macro
//
//  Created by 김나훈 on 12/5/23.
//

import MacroDesignSystem
import UIKit

final class UserResultCell: UICollectionViewCell {
    
    weak var delegate: PostCollectionViewDelegate?
    
    var userNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
}

private extension UserResultCell {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        addSubview(userNameLabel)
        addSubview(profileImageView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 36),
            profileImageView.heightAnchor.constraint(equalToConstant: 36),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Methods

extension UserResultCell {
    
    func configure(with profile: UserProfile) {
        userNameLabel.text = profile.name
        guard let imageUrl = profile.imageUrl else {
            self.profileImageView.image = UIImage.appImage(.ProfileDefaultImage)
            return
        }
        guard let url = URL(string: imageUrl) else { return }
            
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            let image = UIImage(data: cachedResponse.data)
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, response, _ in
                if let data = data, let image = UIImage(data: data) {
                    let cachedResponse = CachedURLResponse(response: response!, data: data)
                                       URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                } else {
                    self.profileImageView.image = UIImage.appImage(.ProfileDefaultImage)
                }
            }.resume()
        }
    }
}

extension UserResultCell {
    enum Padding {
        static let LabelSide: CGFloat = 30
    }
}
