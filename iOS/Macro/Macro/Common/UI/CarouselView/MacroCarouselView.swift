//
//  MacroCarouselView.swift
//  Macro
//
//  Created by 김경호 on 11/22/23.
//

import Combine
import UIKit

class MacroCarouselView<T: CarouselViewProtocol>: UIView {

    // MARK: - Properties
    let viewModel: T
    private let readInputSubject: PassthroughSubject<ReadViewModel.Input, Never>?
    private let writeInputSubject: PassthroughSubject<WriteViewModel.Input, Never>?
    
    private let viewType: CarouselViewType
    private var subscriptions: Set<AnyCancellable> = []
    private var addImageOutputSubject: PassthroughSubject<Bool, Never> = .init()
    private var didScrollSubject: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - UI Componenets
    private lazy var macroCarouselCollectionView = MacroCarouselCollectionView(viewModel: viewModel, addImageOutputSubject: addImageOutputSubject, viewType: viewType)
    
    internal lazy var pageController: UIPageControl = {
        let pageController = UIPageControl()
        pageController.numberOfPages = viewModel.items.count + ((viewType == .write || viewModel.items.isEmpty ) ? 1 : 0 )
        pageController.currentPage = viewModel.pageIndex
        pageController.pageIndicatorTintColor = UIColor.appColor(.purple1)
        pageController.currentPageIndicatorTintColor = UIColor.appColor(.purple2)
        return pageController
    }()

    internal let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "문구를 입력하세요"
        textField.font = UIFont.appFont(.baeEunBody)
        return textField
    }()
    
    internal var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunBody)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init
    
    init(addImageOutputSubject: PassthroughSubject<Bool, Never>, didScrollOutputSubject: PassthroughSubject<Int, Never>, inputSubject: PassthroughSubject<WriteViewModel.Input, Never>, viewModel: T) {
        self.writeInputSubject = inputSubject
        self.viewType = .write
        self.addImageOutputSubject = addImageOutputSubject
        self.didScrollSubject = didScrollOutputSubject
        self.viewModel = viewModel
        self.readInputSubject = nil
        super.init(frame: .zero)
        
        setLayout()
    }
    
    init(didScrollOutputSubject: PassthroughSubject<Int, Never>, inputSubject: PassthroughSubject<ReadViewModel.Input, Never>, viewModel: T) {
        self.viewType = .read
        self.didScrollSubject = didScrollOutputSubject
        self.readInputSubject = inputSubject
        self.viewModel = viewModel
        self.writeInputSubject = nil
        super.init(frame: .zero)
        
        setLayout()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func descriptionTextFieldDidChange(_ sender: Any?) {
        guard let description = self.descriptionTextField.text else { return }
        writeInputSubject?.send(.imageDescriptionUpdate(index: viewModel.carouselCurrentIndex, description: description))
    }
}

// MARK: - UI Settings

private extension MacroCarouselView {
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setupBasedOnViewType()
        setLayoutConstraints()
    }
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        macroCarouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pageController.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        addSubview(macroCarouselCollectionView)
        addSubview(pageController)
    }
    
    func setupBasedOnViewType() {
        if viewType == .write {
            setDescriptionTextField()
        } else {
            setDescriptionLabel()
        }
    }
    
    func setDescriptionTextField() {
        
        addSubview(descriptionTextField)
        
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTextField.topAnchor.constraint(equalTo: macroCarouselCollectionView.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: macroCarouselCollectionView.leadingAnchor, constant: 50),
            descriptionTextField.trailingAnchor.constraint(equalTo: macroCarouselCollectionView.trailingAnchor, constant: -50),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        descriptionTextField.addTarget(self, action: #selector(descriptionTextFieldDidChange), for: .editingChanged)
    }
    
    func setDescriptionLabel() {
        addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: macroCarouselCollectionView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: macroCarouselCollectionView.leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: macroCarouselCollectionView.trailingAnchor, constant: -50)
        ])
        
        descriptionTextField.addTarget(self, action: #selector(descriptionTextFieldDidChange), for: .editingChanged)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            macroCarouselCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            macroCarouselCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            macroCarouselCollectionView.widthAnchor.constraint(equalToConstant: UIScreen.width),
            macroCarouselCollectionView.heightAnchor.constraint(equalToConstant: Const.itemSize.height),
            
            pageController.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pageController.centerXAnchor.constraint(equalTo: macroCarouselCollectionView.centerXAnchor)
        ])
    }
        
}

// MARK: - Methods

extension MacroCarouselView {
    func updateData(_ newData: [UIImage?]) {
        viewModel.items = newData
        self.pageController.numberOfPages = viewModel.items.count + ((viewType == .write || viewModel.items.isEmpty ) ? 1 : 0 )
        
        DispatchQueue.main.async {
            self.macroCarouselCollectionView.reloadData()
            self.pageController.reloadInputViews()
        }
    }
}

// MARK: - LayoutMetrics
private enum Const {
  static let itemSize = CGSize(width: 300, height: 300)
  static let itemSpacing = 24.0
  
}
