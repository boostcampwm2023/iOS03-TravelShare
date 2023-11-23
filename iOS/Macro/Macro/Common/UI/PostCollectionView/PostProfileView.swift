//
//  PostProfileView.swift
//  Macro
//
//  Created by Byeon jinha on 11/17/23.
//

import Combine
import UIKit

final class PostProfileView<T: PostCollectionViewProtocol>: UIView {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var viewModel: T?
    
    // MARK: - UI Components
    
    private let viewCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let likeImageView: UIImageView = {
        let image: UIImage? = UIImage.appImage(.handThumbsup)
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        imageView.tintColor = UIColor.appColor(.purple5)
        return imageView
    }()
    
    private let likeCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let viewImageView: UIImageView = {
        let image: UIImage? = UIImage.appImage(.eyes)
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        imageView.tintColor = UIColor.appColor(.purple5)
        return imageView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Handle Gesture
    
    @objc private func profileImageTap(_ sender: UITapGestureRecognizer) {
        guard let userId: String = self.userNameLabel.text else { return }
        viewModel?.navigateToProfileView(userId: userId)
    }
    
    @objc private func likeImageViewTap(_ sender: UITapGestureRecognizer) {
        guard let likeCount: Int = Int(self.likeCountLabel.text ?? "0") else { return }
        viewModel?.touchLike(postId: "") { isLike in
            DispatchQueue.main.async { [weak self] in
                if isLike {
                    self?.likeImageView.image = UIImage.appImage(.handThumbsupFill)
                    self?.likeCountLabel.text = "\(likeCount + 1)"
                } else {
                    self?.likeImageView.image = UIImage.appImage(.handThumbsup)
                    self?.likeCountLabel.text = "\(likeCount - 1)"
                }
            }
        }
    }
    
}

// MARK: - UI Settings

private extension PostProfileView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        viewImageView.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.addSubview(profileImageView)
        self.addSubview(userNameLabel)
        self.addSubview(viewCountLabel)
        self.addSubview(viewImageView)
        self.addSubview(likeCountLabel)
        self.addSubview(likeImageView)
    }
    
    func setLayoutConstraints() {
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 36),
            profileImageView.heightAnchor.constraint(equalToConstant: 36),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            viewCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            viewCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            viewImageView.trailingAnchor.constraint(equalTo: viewCountLabel.leadingAnchor, constant: -10),
            viewImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            viewImageView.widthAnchor.constraint(equalToConstant: 16),
            viewImageView.heightAnchor.constraint(equalToConstant: 16),
            
            likeCountLabel.trailingAnchor.constraint(equalTo: viewImageView.leadingAnchor, constant: -20),
            likeCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            likeImageView.trailingAnchor.constraint(equalTo: likeCountLabel.leadingAnchor, constant: -10),
            likeImageView.widthAnchor.constraint(equalToConstant: 16),
            likeImageView.heightAnchor.constraint(equalToConstant: 16),
            likeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func addTapGesture() {
        profileImageView.isUserInteractionEnabled = true
        let profileImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTap(_:)))
        profileImageView.addGestureRecognizer(profileImageViewTapGesture)
        
        likeImageView.isUserInteractionEnabled = true
        let likeImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(likeImageViewTap(_:)))
        likeImageView.addGestureRecognizer(likeImageViewTapGesture)
    }
    
}

// MARK: - Bind

extension PostProfileView {
    func bind(viewModel: T) {
        self.viewModel = viewModel
    }
}

// MARK: - Method

extension PostProfileView {
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        addTapGesture()
    }
    
    func configure(item: PostFindResponse) {
        viewModel?.loadImage(profileImageStringURL: item.writer.imageUrl ?? "https://user-images.githubusercontent.com/118811606/285184604-1e5983fd-0b07-4bfe-9c17-8b147f237517.png") { profileImage in
            DispatchQueue.main.async { [self] in
                if let image = profileImage {
                    profileImageView.image = image
                } else {
                    let defaultImage = UIImage.appImage(.ProfileDefaultImage)
                    profileImageView.image = defaultImage
                }
                profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
            }
        }
        userNameLabel.text = item.writer.name
        likeCountLabel.text = "\(item.likeNum)"
        viewCountLabel.text = "\(item.viewNum)"
    }
    
}
