//
//  PostContentView.swift
//  Macro
//
//  Created by Byeon jinha on 11/17/23.
//

import UIKit

class PostContentView: UIView {
    
    // MARK: - UI Components
    
    let mainImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = ConerRadius.mainImageView
        return imageView
    }()
    
    let opcityView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.appColor(.opacity30)
        view.layer.cornerRadius = ConerRadius.mainImageView
        return view
    }()
    
    let title: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.blue1)
        label.font = UIFont.appFont(.baeEunTitle1)
        return label
    }()
    
    let summary: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.blue1)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            mainImageView.heightAnchor.constraint(equalToConstant: Metrics.mainImageViewHeight),
            mainImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            opcityView.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            opcityView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            opcityView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            opcityView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            
            title.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            
            summary.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            summary.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Padding.summaryTop),
            summary.leadingAnchor.constraint(greaterThanOrEqualTo: mainImageView.leadingAnchor, constant: Padding.summaryLeading),
            summary.trailingAnchor.constraint(lessThanOrEqualTo: mainImageView.trailingAnchor, constant: Padding.summaryTrailing)
        ])
    }
    
}

// MARK: - Methods

extension PostContentView {
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
    func configure(item: PostResponse ) {
        loadImage(profileImageStringURL: item.routeInfo.image) { image in
            DispatchQueue.main.async { [self] in
                mainImageView.image = image
                title.text = item.routeInfo.title
                summary.text = item.routeInfo.summary
                
            }
        }
    }
}

// MARK: - LayoutMetrics

extension PostContentView {
    
    enum Metrics {
        static let mainImageViewHeight: CGFloat = 200
    }
    
    enum Padding {
        static let summaryTop: CGFloat = 4
        static let summaryLeading: CGFloat = 10
        static let summaryTrailing: CGFloat = -10
    }
    
    enum ConerRadius {
        static let mainImageView: CGFloat = 20
    }
}

// TODO: 현재 Network 모듈이 잘 이해되지 않아 작성한 코드입니다. 차후 옮기는 작업이 필요합니다.

extension PostContentView {
    
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
