//
//  PostCollectionViewCell.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import UIKit

final class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    let postContentView: PostContentView = PostContentView()
    let postProfileView: PostProfileView = PostProfileView()
    
    // MARK: - Properties
    static let identifier = "PostCollectionViewCell"
    var homeViewModel: HomeViewModel?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI Settings

private extension PostCollectionViewCell {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        postContentView.translatesAutoresizingMaskIntoConstraints = false
        postProfileView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.addSubview(postContentView)
        self.addSubview(postProfileView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            postContentView.topAnchor.constraint(equalTo: self.topAnchor),
            postContentView.heightAnchor.constraint(equalToConstant: Metrics.postContentViewHeight),
            postContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            postProfileView.topAnchor.constraint(equalTo: postContentView.bottomAnchor, constant: Padding.postProfileViewTop),
            postProfileView.heightAnchor.constraint(equalToConstant: Metrics.postProfileViewHeight),
            postProfileView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postProfileView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
        ])
    }
    
    func componetConfigure(item: PostResponse, viewModel: HomeViewModel) {
        if postContentView.viewModel == nil {
            postContentView.setLayout()
            postContentView.configure(item: item)
            postContentView.bind(viewModel: viewModel)
            }
        if postProfileView.viewModel == nil {
            postProfileView.setLayout()
            postProfileView.configure(item: item)
            postProfileView.bind(viewModel: viewModel)
           }
        
    }
}

// MARK: - Methods

extension PostCollectionViewCell {
    
    func configure(item: PostResponse, viewModel: HomeViewModel) {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        componetConfigure(item: item, viewModel: viewModel)
    }
}

// MARK: - LayoutMetrics

private extension PostCollectionViewCell {
    
    enum Metrics {
        static let postContentViewHeight: CGFloat = 200
        static let postProfileViewHeight: CGFloat = 40
    }
    
    enum Padding {
        static let postProfileViewTop: CGFloat = 10
    }
}
