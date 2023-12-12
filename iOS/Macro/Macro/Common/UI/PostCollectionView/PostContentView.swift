//
//  PostContentView.swift
//  Macro
//
//  Created by Byeon jinha on 11/17/23.
//

import Combine
import MacroNetwork
import UIKit

final class PostContentView: UIView {
    
    // MARK: - Properties
    private var imageUrl: String?
    private var cancellables = Set<AnyCancellable>()
    var viewModel: PostCollectionViewModel?
    private let provider = APIProvider(session: URLSession.shared)
    private let inputSubject: PassthroughSubject<PostCollectionViewModel.Input, Never> = .init()
    var readViewDisappear: PassthroughSubject<ReadPost, Never> = .init()
    weak var delegate: PostCollectionViewDelegate?
    var postId: Int?
    
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
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handle Gesture
    
    @objc private func contentTap(_ sender: UITapGestureRecognizer) {
        guard let postId: Int = self.postId else { return }
        let provider = APIProvider(session: URLSession.shared)
        let readuseCase = ReadPostUseCase(provider: provider)
        let readViewModel = ReadViewModel(useCase: readuseCase, postId: postId, pathcher: Patcher(provider: APIProvider(session: URLSession.shared)), reporter: Reporter(provider: provider))
        let readViewController = ReadViewController(viewModel: readViewModel, readViewDisappear: readViewDisappear)
        delegate?.didTapContent(viewController: readViewController)
        
        inputSubject.send(.increaseView(postId))
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
// MARK: - Methods

extension PostContentView {
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        addTapGesture()
    }
    
    func configure(item: PostFindResponse, viewModel: PostCollectionViewModel?, readViewDisappear: PassthroughSubject<ReadPost, Never>) {
            self.viewModel = viewModel
            self.readViewDisappear = readViewDisappear
            self.imageUrl = item.imageUrl

            if let imageUrl = item.imageUrl, isValidUrl(urlString: imageUrl) {
                self.loadImage(profileImageStringURL: imageUrl)
            } else {
                setDefaultProfileImage()
            }

            title.text = item.title
            summary.text = item.summary
            postId = item.postId
        }

        func loadImage(profileImageStringURL: String) {
            guard let url = URL(string: profileImageStringURL) else {
                setDefaultProfileImage()
                return
            }
            
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
        mainImageView.image = image
    }
    
    func resetContents() {
        mainImageView.image = nil
        title.text = ""
        summary.text = ""
        postId = nil
    }
}
