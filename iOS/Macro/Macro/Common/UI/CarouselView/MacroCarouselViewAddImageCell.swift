//
//  MacroCarouselViewAddImageCell.swift
//  Macro
//
//  Created by 김경호 on 11/23/23.
//

import Combine
import UIKit

final class MacroCarouselViewAddImageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MacroCarouselViewAddImageCell"
    var addImageButtonOutputSubject: PassthroughSubject<Bool, Never> = .init()
    
    // MARK: - UI Componenets
    
    private let addPictureView: MacroCarouselViewCelladdPictureView = MacroCarouselViewCelladdPictureView()
    
    // MARK: - Init
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        addTapGesture()
    }
}

extension MacroCarouselViewAddImageCell {
    
}

// MARK: - UI Settings

extension MacroCarouselViewAddImageCell {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        addPictureView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        self.contentView.addSubview(self.addPictureView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            self.addPictureView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.addPictureView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.addPictureView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.addPictureView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
    }
    
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}
// MARK: - Methods
extension MacroCarouselViewAddImageCell {
    
    @objc private func addImageButtonTouched(_ sender: UITapGestureRecognizer) {
        addImageButtonOutputSubject.send(true)
    }
    
    func addTapGesture() {
        addPictureView.isUserInteractionEnabled = true
        let addPictrueViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageButtonTouched(_:)))
        addPictureView.addGestureRecognizer(addPictrueViewTapGesture)
    }
}
