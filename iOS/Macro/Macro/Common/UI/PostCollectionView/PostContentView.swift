//
//  PostContentView.swift
//  Macro
//
//  Created by Byeon jinha on 11/17/23.
//

import Combine
import UIKit

final class PostContentView<T: PostCollectionViewProtocol>: UIView {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var viewModel: T?
    
    // MARK: - UI Components
    
    private let mainImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let opcityView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.appColor(.opacity30)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let title: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.blue1)
        label.font = UIFont.appFont(.baeEunTitle1)
        return label
    }()
    
    private let summary: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.blue1)
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
    
    // MARK: - Handle Gesture
    
    @objc private func contentTap(_ sender: UITapGestureRecognizer) {
        guard let postId: String = self.title.text else { return }
        viewModel?.navigateToReadView(postId: postId)
    }
    
}

// MARK: - UI Settings

private extension PostContentView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        opcityView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        summary.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.addSubview(mainImageView)
        mainImageView.addSubview(opcityView)
        mainImageView.addSubview(title)
        mainImageView.addSubview(summary)
    }
    
    func setLayoutConstraints() {
        
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            mainImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            opcityView.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            opcityView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            opcityView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            opcityView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            
            title.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            
            summary.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            summary.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            summary.leadingAnchor.constraint(greaterThanOrEqualTo: mainImageView.leadingAnchor, constant: 10),
            summary.trailingAnchor.constraint(lessThanOrEqualTo: mainImageView.trailingAnchor, constant: -10)
        ])
    }
    
    func addTapGesture() {
        mainImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentTap(_:)))
        mainImageView.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - Bind

extension PostContentView {
    
    func bind(viewModel: T) {
        self.viewModel = viewModel
    }
    
}
// MARK: - Methods

extension PostContentView {
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        addTapGesture()
    }
    
    func configure(item: PostFindResponse) {
        viewModel?.loadImage(profileImageStringURL: item.imageUrl ?? "https://user-images.githubusercontent.com/118811606/285184604-1e5983fd-0b07-4bfe-9c17-8b147f237517.png") { image in
            DispatchQueue.main.async { [self] in
                mainImageView.image = image
                title.text = item.title
                summary.text = item.summary
                
            }
        }
    }
    
}