//
//  MacroCarouselCollectionView.swift
//  Macro
//
//  Created by Byeon jinha on 12/4/23.
//

import Combine
import UIKit

class MacroCarouselCollectionView<T: CarouselViewProtocol>: UICollectionView,
                                                            UICollectionViewDataSource,
                                                            UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    let viewModel: T
    let viewType: CarouselViewType
    private var addImageOutputSubject: PassthroughSubject<Bool, Never>
    
    // MARK: - Init
    
    init(viewModel: T, addImageOutputSubject: PassthroughSubject<Bool, Never>, viewType: CarouselViewType) {
        
        self.viewModel = viewModel
        self.addImageOutputSubject = addImageOutputSubject
        self.viewType = viewType
        
        let collectionViewFlowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = Const.itemSize
            layout.minimumLineSpacing = Const.itemSpacing
            layout.minimumInteritemSpacing = 0
            return layout
        }()
        
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count + ((self.viewType == .write || viewModel.items.isEmpty ) ? 1 : 0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.viewType == .write, indexPath.row == viewModel.items.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MacroCarouselViewAddImageCell.identifier, for: indexPath) as? MacroCarouselViewAddImageCell else {
                let cell = MacroCarouselViewAddImageCell()
                cell.addImageButtonOutputSubject = addImageOutputSubject
                return cell
            }
            cell.addImageButtonOutputSubject = addImageOutputSubject
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MacroCarouselViewCell.id, for: indexPath) as? MacroCarouselViewCell else {
                return MacroCarouselViewCell()
            }
            
            if viewModel.items.count > indexPath.item, let image = viewModel.items[indexPath.item] {
                cell.prepare(image: image)
            } else {
                cell.prepare(image: UIImage.appImage(.profileDefaultImage))
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (UIScreen.width - Const.itemSize.width) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        viewModel.pageIndex = Int(round(scrolledOffsetX / cellWidth))
        
        let visibleIndex = max(0, viewModel.pageIndex)
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(visibleIndex) * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
}

// MARK: - Methods
private extension MacroCarouselCollectionView {
    
    func configure() {
        self.isScrollEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = true
        self.clipsToBounds = true
        self.register(MacroCarouselViewCell.self, forCellWithReuseIdentifier: MacroCarouselViewCell.id)
        self.register(MacroCarouselViewAddImageCell.self, forCellWithReuseIdentifier: MacroCarouselViewAddImageCell.identifier)
        self.isPagingEnabled = false
        self.contentInsetAdjustmentBehavior = .never
        self.decelerationRate = .fast
        self.dataSource = self
        self.delegate = self
    }
    
}

// MARK: - LayoutMetrics
private enum Const {
    static let itemSize = CGSize(width: 300, height: 300)
    static let itemSpacing = 24.0
    
}
