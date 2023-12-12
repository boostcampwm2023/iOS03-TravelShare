//
//  PostLikeView.swift
//  Macro
//
//  Created by Byeon jinha on 12/12/23.
//

import Combine
import UIKit

class PostLikeView: UIView {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var viewModel: ReadViewModel?
    private let inputSubject: PassthroughSubject<PostCollectionViewModel.Input, Never> = .init()
    var postId: Int?
    
    // MARK: - UI Components
    
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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings

private extension PostLikeView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.addSubview(likeImageView)
        self.addSubview(likeCountLabel)
    }
    
    func setLayoutConstraints() {
        
        NSLayoutConstraint.activate([
            likeImageView.topAnchor.constraint(equalTo: self.topAnchor),
            likeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            likeCountLabel.centerYAnchor.constraint(equalTo: self.likeImageView.centerYAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeImageView.trailingAnchor, constant: 10)
        ])
    }
    
}
// MARK: - Methods

extension PostLikeView {
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
    func updatePost(_ readPost: ReadPost) {
        likeCountLabel.text = "\(readPost.likeNum)"
        self.likeImageView.image = readPost.liked ? UIImage.appImage(.handThumbsupFill) : UIImage.appImage(.handThumbsup)
        self.likeImageView.tintColor = readPost.liked ? UIColor.appColor(.purple2) : UIColor.appColor(.purple5)
    }
    
    func updateLike(_ likePostResponse: LikePostResponse) {
        self.likeCountLabel.text = "\(likePostResponse.likeNum)"
        self.likeImageView.image = likePostResponse.liked ? UIImage.appImage(.handThumbsupFill) : UIImage.appImage(.handThumbsup)
        self.likeImageView.tintColor = likePostResponse.liked ? UIColor.appColor(.purple2) : UIColor.appColor(.purple5)
    }
}
