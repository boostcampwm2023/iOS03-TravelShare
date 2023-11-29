//
//  MapCollcectionView.swift
//  Macro
//
//  Created by Byeon jinha on 11/29/23.
//

import UIKit

final class MapCollectionView<T: MapCollectionViewProtocol>: UICollectionView,
                                                               UICollectionViewDelegate,
                                                               UICollectionViewDataSource,
                                                               UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    let viewModel: T
    
    // MARK: - Initialization
    
    init(frame: CGRect, viewModel: T) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.appColor(.blue1)
        
        self.register(MapCollectionViewCell<T>.self, forCellWithReuseIdentifier: "MapCollectionViewCell")
        
        self.showsVerticalScrollIndicator = false
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.travels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MapCollectionViewCell",
            for: indexPath) as? MapCollectionViewCell<T> else { return UICollectionViewCell()
        }
        let item: TravelInfo = viewModel.travels[indexPath.row]
        cell.configure(item: item, viewModel: viewModel)
        
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
