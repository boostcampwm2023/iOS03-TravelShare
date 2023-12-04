//
//  HomeCollectionView.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import Combine
import UIKit

final class PostCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    let viewModel: PostCollectionViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var postDelegate: PostCollectionViewDelegate?
    private let inputSubject: PassthroughSubject<PostCollectionViewModel.Input, Never> = .init()
    
    // MARK: - Initialization
    
    init(frame: CGRect, viewModel: PostCollectionViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.appColor(.blue1)
        
        self.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        
        self.showsVerticalScrollIndicator = false
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell",
                                                            for: indexPath) as? PostCollectionViewCell
        else { return UICollectionViewCell() }
        cell.delegate = postDelegate
        let item = viewModel.posts[indexPath.row]
        cell.configure(item: item, viewModel: viewModel, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
    
}
