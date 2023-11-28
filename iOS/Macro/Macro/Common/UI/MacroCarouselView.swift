//
//  MacroCarouselView.swift
//  Macro
//
//  Created by 김경호 on 11/22/23.
//

import Combine
import UIKit

class MacroCarouselView: UIView {

    // MARK: - Properties
    
    struct Const {
        let itemSize: CGSize
        let itemSpacing: Double
    }
    
    enum ViewType {
        case read
        case write
    }
    
    var items: [UIImage?] = []
    private let const: Const
    private let viewType: ViewType
    private var subscriptions: Set<AnyCancellable> = []
    private var addImageOutputSubject: PassthroughSubject<Bool, Never> = .init()
    private var didScrollOutputSubject: PassthroughSubject<Int, Never> = .init()
    
    var pageIndex = 0 {
        didSet {
            self.pageController.currentPage = pageIndex
            self.didScrollOutputSubject.send(pageIndex)
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
        view.register(MacroCarouselViewAddImageCell.self, forCellWithReuseIdentifier: MacroCarouselViewAddImageCell.id)
        view.isPagingEnabled = false
        view.contentInsetAdjustmentBehavior = .never
        view.decelerationRate = .fast
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageController: UIPageControl = {
        let pageController = UIPageControl()
        pageController.numberOfPages = self.items.count + ((viewType == .write || items.isEmpty ) ? 1 : 0 )
        pageController.currentPage = pageIndex
        pageController.pageIndicatorTintColor = UIColor.appColor(.purple1)
        pageController.currentPageIndicatorTintColor = UIColor.appColor(.purple2)
        return pageController
    }()

    // MARK: - Init
    
    init(const: Const, addImageOutputSubject: PassthroughSubject<Bool, Never>, didScrollOutputSubject : PassthroughSubject<Int, Never>) {
        self.const = const
        self.viewType = .write
        self.addImageOutputSubject = addImageOutputSubject
        self.didScrollOutputSubject = didScrollOutputSubject
        super.init(frame: .zero)
        setLayout()
    }
    
    init(const: Const, didScrollOutputSubject : PassthroughSubject<Int, Never>) {
        self.const = const
        self.viewType = .read
        self.didScrollOutputSubject = didScrollOutputSubject
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
        items.count + ((viewType == .write || items.isEmpty ) ? 1 : 0 )
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewType == .write, indexPath.row == items.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MacroCarouselViewAddImageCell.id, for: indexPath) as? MacroCarouselViewAddImageCell else {
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
            
            if items.count > indexPath.item, let image = items[indexPath.item] {
                cell.prepare(image: image)
            } else {
                cell.prepare(image: UIImage.appImage(.photo))
            }
            return cell
        }
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

// MARK: - func

extension MacroCarouselView {
    func updateData(_ newData: [UIImage?]) {
        items = newData
        self.pageController.numberOfPages = items.count + ((viewType == .write || items.isEmpty ) ? 1 : 0 )
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.pageController.reloadInputViews()
        }
    }
}
