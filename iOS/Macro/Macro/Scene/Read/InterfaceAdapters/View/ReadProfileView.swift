//
//  ReadProfileView.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Combine
import UIKit

final class ReadProfileView: UIView {
    
    // MARK: - Properties
    
    private let inputSubject: PassthroughSubject<ReadViewModel.Input, Never>
    
    // MARK: - UI Components
    
    private let userNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.image = UIImage.appImage(.profileDefaultImage)
        return imageView
    }()
    
    // MARK: - Init
    
    init(inputSubject: PassthroughSubject<ReadViewModel.Input, Never>) {
        self.inputSubject = inputSubject
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Code로 작성해주세요.")
    }
    
}

// MARK: - UI Settings

extension ReadProfileView {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        self.addSubview(profileImageView)
        self.addSubview(userNameLabel)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileImageViewWidth),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileImageViewHeight),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Padding.profileImageViewLeading),
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: Padding.userNameLabelLeading),
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        addTapGesture()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
    }

}

// MARK: - Method

extension ReadProfileView {
    
    func updateProfil(_ writer: Writer) {
        DispatchQueue.main.async { [weak self] in
            guard let width = self?.profileImageView.frame.width else { return }
            self?.profileImageView.layer.cornerRadius = width / 2
            self?.profilImageUpdate(profileImageStringURL: writer.imageUrl ?? "") { profileImage in
                
                if let image = profileImage {
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                } else {
                    let defaultImage = UIImage.appImage(.profileDefaultImage)
                    DispatchQueue.main.async {
                        self?.profileImageView.image = defaultImage
                    }
                }
            }
            self?.userNameLabel.text = writer.name
        }
    }

    func profilImageUpdate(profileImageStringURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: profileImageStringURL) else { return }
      
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            let image = UIImage(data: cachedResponse.data)
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, response, _ in
                if let data = data, let image = UIImage(data: data) {
                    let cachedResponse = CachedURLResponse(response: response!, data: data)
                                       URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    private func addTapGesture() {
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTap(_:)))
        profileImageView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Handdle Gesture

private extension ReadProfileView {
    @objc private func profileImageTap(_ sender: UITapGestureRecognizer) {
        guard let userId: String = self.userNameLabel.text else { return }
        inputSubject.send(.searchUser)
    }
}

// MARK: - LayoutMetrics

private extension ReadProfileView {
    
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
