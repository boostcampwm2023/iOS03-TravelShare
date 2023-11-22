//
//  SearchCollectionView.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import UIKit

final class SearchCollectionView: UICollectionView {
   
    // MARK: - Properties
    
    var posts: [PostFindResponse] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.appColor(.blue1)
        
        self.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
        self.showsVerticalScrollIndicator = false
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension SearchCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
}

extension SearchCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCollectionViewCell.identifier,
            for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell()
        }
        let item: PostFindResponse = self.posts[indexPath.row]
        cell.configure(item: item)
        
        return cell
    }
}

extension SearchCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Metrics.cellWidth, height: Metrics.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Padding.collectionViewMiniMumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: Padding.collectionViewBottom, right: 0)
      }
}

// MARK: - LayoutMetrics

private extension SearchCollectionView {
    
    enum Metrics {
        static let cellWidth: CGFloat = UIScreen.width - 20
        static let cellHeight: CGFloat = 250
    }
    
    enum Padding {
        static let collectionViewMiniMumSpacing: CGFloat = 20
        static let collectionViewBottom: CGFloat = 80
    }
}
