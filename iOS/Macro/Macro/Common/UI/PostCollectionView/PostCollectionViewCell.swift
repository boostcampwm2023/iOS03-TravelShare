//
//  PostCollectionViewCell.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import UIKit

final class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let identifier = "PostCollectionViewCell"
    var viewModel: PostCollectionViewModel?
    weak var delegate: PostCollectionViewDelegate?
    
    // MARK: - UI Components
    
    let postContentView: PostContentView
    let postProfileView: PostProfileView
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        self.postContentView = PostContentView()
        self.postProfileView = PostProfileView()
        super.init(frame: frame)
        
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

extension PostCollectionViewCell {
    
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
    
    func componetConfigure(item: PostFindResponse) {
        postContentView.setLayout()
        postContentView.configure(item: item, viewModel: self.viewModel)
        postProfileView.setLayout()
        postProfileView.configure(item: item, viewModel: self.viewModel)
    }
}

// MARK: - Methods

extension PostCollectionViewCell {
    
    func configure(item: PostFindResponse, viewModel: PostCollectionViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        postContentView.configure(item: item, viewModel: viewModel)
        postProfileView.configure(item: item, viewModel: viewModel)
        postProfileView.indexPath = indexPath
        postContentView.delegate = delegate
        postProfileView.delegate = delegate
        postProfileView.bind()
        postContentView.bind()
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        componetConfigure(item: item)
    }
    
}
