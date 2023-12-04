//
//  RelatedLocationCollectionView.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import Foundation
import UIKit

final class RelatedLocationCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let viewModel: LocationInfoViewModel
    
    init(frame: CGRect, viewModel: LocationInfoViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(RelatedLocationCell.self, forCellWithReuseIdentifier: "RelatedLocationCell")
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(viewModel.relatedLocation.count)
        return viewModel.relatedLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedLocationCell", for: indexPath) as? RelatedLocationCell else {
            return UICollectionViewCell()
        }
        let location = viewModel.relatedLocation[indexPath.row]
        cell.configure(with: location)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width - 20, height: 30)
    }
}
