//
//  UserResultCell.swift
//  Macro
//
//  Created by 김나훈 on 12/5/23.
//

import MacroDesignSystem
import UIKit

final class UserResultCell: UICollectionViewCell {
    
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
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Padding.LabelSide),
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Padding.LabelSide),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
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
        guard let imageUrl = profile.imageUrl else { return }
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                } else {
                    debugPrint("Failed to download image form \(url)")
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
