//
//  PostCollectionViewCell.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import Combine
import UIKit

final class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let identifier = "PostCollectionViewCell"
    var viewModel: PostCollectionViewModel?
    var readViewDisappear: PassthroughSubject<ReadPost, Never> = .init()
    weak var delegate: PostCollectionViewDelegate?
    
    // MARK: - UI Components
    
    let postContentView: PostContentView
    let postProfileView: PostProfileContainerView
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        self.postContentView = PostContentView()
        self.postContentView.readViewDisappear = self.readViewDisappear
        self.postProfileView = PostProfileContainerView()
        super.init(frame: frame)
        
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postContentView.resetContents()
        postProfileView.resetContents()
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

}

// MARK: - Methods

extension PostCollectionViewCell {
    
    func configure(item: PostFindResponse, viewModel: PostCollectionViewModel, indexPath: IndexPath, readViewDisappear: PassthroughSubject<ReadPost, Never>) {
        self.viewModel = viewModel
        self.readViewDisappear = readViewDisappear
        postContentView.configure(item: item, viewModel: viewModel, readViewDisappear: self.readViewDisappear)
        postProfileView.configure(item: item, viewModel: viewModel)
        postContentView.setLayout()
        postProfileView.setLayout()
        postProfileView.indexPath = indexPath
        postContentView.delegate = delegate
        postProfileView.delegate = delegate
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    
}
