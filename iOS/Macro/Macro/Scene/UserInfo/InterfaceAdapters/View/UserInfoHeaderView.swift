//
//  File.swift
//  Macro
//
//  Created by Byeon jinha on 11/23/23.
//

import UIKit

final class UserInfoHeaderView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunLargeTitle)
        return label
    }()
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
}

// MARK: UI Settings

extension UserInfoHeaderView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.addSubview(userNameLabel)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            userNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupLayout(userInfo: UserInfo) {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        userNameLabel.text = userInfo.name
    }
}

extension UserInfoHeaderView {
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
