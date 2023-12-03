//
//  UserInfoProfileView.swift
//  Macro
//
//  Created by Byeon jinha on 11/27/23.
//

import UIKit

class UserInfoProfileView: UIView {
    
    // MARK: - UI Components
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size = CGSize(width: 100, height: 100)
        imageView.clipsToBounds = true
        imageView.makeCircular()
        return imageView
    }()
    
    private let userFollowerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.purple4)
        label.font = UIFont.appFont(.baeEunBody)
        label.text = "팔로워"
        return label
    }()
    
    private let userFollowerCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.purple4)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let userIntroduceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.purple3)
        label.font = UIFont.appFont(.baeEunCallout)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

extension UserInfoProfileView {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userFollowerLabel.translatesAutoresizingMaskIntoConstraints = false
        userFollowerCountLabel.translatesAutoresizingMaskIntoConstraints = false
        userIntroduceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        self.addSubview(userProfileImageView)
        self.addSubview(userFollowerLabel)
        self.addSubview(userFollowerCountLabel)
        self.addSubview(userIntroduceLabel)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            userProfileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            userProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 100),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userFollowerLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 24),
            userFollowerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            userFollowerCountLabel.leadingAnchor.constraint(equalTo: userFollowerLabel.trailingAnchor, constant: 10),
            userFollowerCountLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            userIntroduceLabel.topAnchor.constraint(equalTo: userFollowerLabel.bottomAnchor, constant: 10),
            userIntroduceLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 24),
            userIntroduceLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.trailingAnchor),
            userIntroduceLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        ])
    }
    
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Methods

extension UserInfoProfileView {
    func configure(item: UserProfile) {
        // TODO: nil 일 경우 default 이미지
        loadImage(profileImageStringURL: item.imageUrl ?? "") { image in
            self.userProfileImageView.image = image
        }
        
    //    self.userFollowerCountLabel.text = "\(item.follower)"
        self.userIntroduceLabel.text = item.introduce
        self.userFollowerCountLabel.text = "\(item.followersNum)"
    }
    
    func updateFollow(item: FollowResponse) {
        self.userFollowerCountLabel.text = "\(item.followCount)"
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
