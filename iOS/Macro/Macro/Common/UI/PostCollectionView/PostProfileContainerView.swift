//
//  PostProfileContainerView.swift
//  Macro
//
//  Created by Byeon jinha on 11/17/23.
//

import Combine
import MacroNetwork
import UIKit

final class PostProfileContainerView: UIView {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var viewModel: PostCollectionViewModel?
    private var imageUrl: String?
    var indexPath: IndexPath?
    private let provider = APIProvider(session: URLSession.shared)
    private let inputSubject: PassthroughSubject<PostCollectionViewModel.Input, Never> = .init()
    weak var delegate: PostCollectionViewDelegate?
    var postId: Int?
    
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
        let image: UIImage? = LikeImage.unliked
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        imageView.tintColor = LikeColor.unliked
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
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handle Gesture
    
    @objc private func profileImageTap(_ sender: UITapGestureRecognizer) {
        guard let indexPath = indexPath else { return }
        guard let viewModel = viewModel else { return }
        let email = viewModel.posts[indexPath.row].writer.email
        viewModel.navigateToProfileView(email: email)
        
        let userInfoViewModel = UserInfoViewModel(postSearcher: viewModel.postSearcher,
                                                  followFeature: viewModel.followFeatrue,
                                                  patcher: Patcher(provider: provider))
        let userInfoViewController = UserInfoViewController(viewModel: userInfoViewModel, userInfo: email)
        delegate?.didTapProfile(viewController: userInfoViewController)
    }
    
}

// MARK: - UI Settings

extension PostProfileContainerView {
    
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
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        addTapGesture()
    }
    
    func addTapGesture() {
        profileImageView.isUserInteractionEnabled = true
        let profileImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTap(_:)))
        profileImageView.addGestureRecognizer(profileImageViewTapGesture)
        
        userNameLabel.isUserInteractionEnabled = true
        let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTap(_:)))
        userNameLabel.addGestureRecognizer(userNameTapGesture)
    }
    
}

// MARK: - Method

extension PostProfileContainerView {
    func configure(item: PostFindResponse, viewModel: PostCollectionViewModel?) {
         self.viewModel = viewModel
         self.imageUrl = item.writer.imageUrl

         if let imageUrl = item.writer.imageUrl, isValidUrl(urlString: imageUrl) {
             self.loadImage(profileImageStringURL: imageUrl, forCellWithIndexPath: indexPath)
         } else {
             setDefaultProfileImage()
         }

         userNameLabel.text = item.writer.name
         likeImageView.image = item.liked ? LikeImage.liked : LikeImage.unliked
         likeImageView.tintColor = item.liked ? LikeColor.liked : LikeColor.unliked
         likeCountLabel.text = "\(item.likeNum)"
         viewCountLabel.text = "\(item.viewNum)"
         postId = item.postId
     }
     
     func loadImage(profileImageStringURL: String, forCellWithIndexPath indexPath: IndexPath?) {
         guard let url = URL(string: profileImageStringURL) else { return }
         
         URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
             DispatchQueue.main.async {
                 if self?.imageUrl == profileImageStringURL {
                     if let data = data, let image = UIImage(data: data) {
                         self?.setProfileImage(image)
                     } else {
                         self?.setDefaultProfileImage()
                     }
                 }
             }
         }.resume()
     }
    
    private func setDefaultProfileImage() {
        let defaultImage = UIImage.appImage(.profileDefaultImage)
        setProfileImage(defaultImage)
    }

    private func setProfileImage(_ image: UIImage?) {
        profileImageView.image = image
    }
    
    func resetContents() {
        profileImageView.image = nil
        userNameLabel.text = ""
        likeCountLabel.text = ""
        viewCountLabel.text = ""
        postId = nil
    }
}

// MARK: - Layout Metrics

extension PostProfileContainerView {
    enum LikeImage {
        static let liked: UIImage? = UIImage.appImage(.handThumbsupFill)
        static let unliked: UIImage? = UIImage.appImage(.handThumbsup)
    }
    enum LikeColor {
        static let liked: UIColor? = UIColor.appColor(.purple2)
        static let unliked: UIColor? = UIColor.appColor(.purple5)
    }
}
