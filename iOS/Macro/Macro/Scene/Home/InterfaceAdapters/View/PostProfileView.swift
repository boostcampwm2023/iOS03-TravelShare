//
//  PostProfileView.swift
//  Macro
//
//  Created by Byeon jinha on 11/17/23.
//

import Combine
import UIKit

final class PostProfileView: UIView {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var viewModel: HomeViewModel?
    private let inputSubject: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    
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
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileImageViewWidth),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileImageViewHeight),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Padding.profileImageViewLeading),
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: Padding.userNameLabelLeading),
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            viewCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Padding.viewCountLabelTrailing),
            viewCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            viewImageView.trailingAnchor.constraint(equalTo: viewCountLabel.leadingAnchor, constant: Padding.viewImageViewTrailing),
            viewImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            viewImageView.widthAnchor.constraint(equalToConstant: Metrics.viewImageViewWidth),
            viewImageView.heightAnchor.constraint(equalToConstant: Metrics.viewImageViewHeight),
            
            likeCountLabel.trailingAnchor.constraint(equalTo: viewImageView.leadingAnchor, constant: Padding.likeCountLabelTrailing),
            likeCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            likeImageView.trailingAnchor.constraint(equalTo: likeCountLabel.leadingAnchor, constant: Padding.likeImageViewTrailing),
            likeImageView.widthAnchor.constraint(equalToConstant: Metrics.likeImageViewWidth),
            likeImageView.heightAnchor.constraint(equalToConstant: Metrics.likeImageViewHieght),
            likeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func addTapGesture() {
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTap(_:)))
        profileImageView.addGestureRecognizer(tapGesture)
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
        loadImage(profileImageStringURL: item.userInfo.name) { profileImage in
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
        userNameLabel.text = item.userInfo.name
        likeCountLabel.text = "\(item.likeNum)"
        viewCountLabel.text = "\(item.viewNum)"
    }
    
    func bind(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        guard let viewModel = self.viewModel else { return }
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
    }
}

// MARK: - Handdle Gesture
private extension PostProfileView {
    @objc private func profileImageTap(_ sender: UITapGestureRecognizer) {
        guard let userId: String = self.userNameLabel.text else { return }
        inputSubject.send(.searchUser(userId))
    }
}

// MARK: - LayoutMetrics

private extension PostProfileView {
    
    enum Metrics {
        static let profileImageViewWidth: CGFloat = 36
        static let profileImageViewHeight: CGFloat = 36
        static let viewImageViewWidth: CGFloat = 16
        static let viewImageViewHeight: CGFloat = 16
        static let likeImageViewWidth: CGFloat = 16
        static let likeImageViewHieght: CGFloat = 16
    }

    enum Padding {
        static let profileImageViewLeading: CGFloat = 10
        static let userNameLabelLeading: CGFloat = 10
        static let viewCountLabelTrailing: CGFloat = -10
        static let viewImageViewTrailing: CGFloat = -10
        static let likeCountLabelTrailing: CGFloat = -20
        static let likeImageViewTrailing: CGFloat = -10
    }
}

// TODO: 현재 Network 모듈이 잘 이해되지 않아 작성한 코드입니다. 차후 옮기는 작업이 필요합니다.
private extension PostProfileView {
    
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
