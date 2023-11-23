//
//  MacroCarouselView.swift
//  Macro
//
//  Created by 김경호 on 11/22/23.
//

import UIKit

class MacroCarouselView: UIView {

    // MARK: - Properties
    
    struct Const {
        let itemSize: CGSize
        let itemSpacing: Double
    }
    
    var items: [UIImage] = []
    private let const: Const
    var pageIndex = 0 {
        didSet {
            self.pageController.currentPage = pageIndex
        }
    }

    // MARK: - UI Componenets
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = const.itemSize
        layout.minimumLineSpacing = const.itemSpacing
        layout.minimumInteritemSpacing = 0
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(MacroCarouselViewCell.self, forCellWithReuseIdentifier: MacroCarouselViewCell.id)
        view.isPagingEnabled = false
        view.contentInsetAdjustmentBehavior = .never
        view.decelerationRate = .fast
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageController: UIPageControl = {
        let pageController = UIPageControl()
        pageController.numberOfPages = self.items.count
        pageController.currentPage = pageIndex
        pageController.pageIndicatorTintColor = UIColor.appColor(.purple1)
        pageController.currentPageIndicatorTintColor = UIColor.appColor(.purple2)
        return pageController
    }()

    // MARK: - Init
    
    init(items: [UIImage], const: Const) {
        self.items = items
        self.const = const
        super.init(frame: .zero)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UI Settings

private extension MacroCarouselView {
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageController.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        addSubview(collectionView)
        addSubview(pageController)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            pageController.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            pageController.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension MacroCarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MacroCarouselViewCell.id, for: indexPath) as? MacroCarouselViewCell else {
            return MacroCarouselViewCell()
        }
        cell.prepare(image: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MacroCarouselView: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = const.itemSize.width + const.itemSpacing
        pageIndex = Int(round(scrolledOffsetX / cellWidth))
        
        // 화면에 나오는 첫 번째 셀의 인덱스를 가져오기
        let visibleIndex = max(0, pageIndex)

        // 화면 중앙으로 정렬하는 contentInset 계산
        let centerX = (scrollView.bounds.width - const.itemSize.width) / 2.0
        let insetX = max(centerX - (CGFloat(visibleIndex) * cellWidth), 0)

        // contentInset 설정
        scrollView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: 0)
        targetContentOffset.pointee = CGPoint(x: CGFloat(visibleIndex) * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
}