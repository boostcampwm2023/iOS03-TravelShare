//
//  PostCollectionViewCell.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import UIKit

final class PostCollectionViewCell<T: PostCollectionViewProtocol>: UICollectionViewCell {
    
    // MARK: - UI Components
    let postContentView: PostContentView = PostContentView<T>()
    let postProfileView: PostProfileView = PostProfileView<T>()
    
    // MARK: - Properties
    let identifier = "PostCollectionViewCell"
    var homeViewModel: T?
    
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
            postContentView.heightAnchor.constraint(equalToConstant: 200),
            postContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            postProfileView.topAnchor.constraint(equalTo: postContentView.bottomAnchor, constant: 10),
            postProfileView.heightAnchor.constraint(equalToConstant: 40),
            postProfileView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postProfileView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
        ])
    }
    
    func componetConfigure(item: PostFindResponse, viewModel: T) {
        if postContentView.viewModel == nil {
            postContentView.setLayout()
            postContentView.bind(viewModel: viewModel)
            postContentView.configure(item: item)
            }
        if postProfileView.viewModel == nil {
            postProfileView.setLayout()
            postProfileView.bind(viewModel: viewModel)
            postProfileView.configure(item: item)
           }
        
    }
}

// MARK: - Methods

extension PostCollectionViewCell {
    
    func configure(item: PostFindResponse, viewModel: T, indexPath: IndexPath) {
        postProfileView.configure(item: item)
        postContentView.configure(item: item)
        postProfileView.indexPath = indexPath
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        componetConfigure(item: item, viewModel: viewModel)
    }

}
