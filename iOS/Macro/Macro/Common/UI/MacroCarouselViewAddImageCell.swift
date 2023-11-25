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
    
    static let id = "MacroCarouselViewAddImageCell"
    var addImageButtonOutputSubject: PassthroughSubject<Bool, Never> = .init()
    
    // MARK: - UI Componenets
    
    private let myView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColor(.purple1)
        button.setTitleColor(UIColor.appColor(.purple4), for: .normal)
        button.setTitle("사진 추가", for: .normal)
        button.titleLabel?.font = UIFont.appFont(.baeEunBody)
        button.addTarget(self, action: #selector(addImageButtonTouched), for: .touchUpInside)
        button.setImage(
            UIImage.appImage(.photo)?
                .withTintColor(UIColor.appColor(.purple4)),
                        for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(self.myView)
        NSLayoutConstraint.activate([
            self.myView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.myView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.myView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.myView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - objc

extension MacroCarouselViewAddImageCell {
    @objc func addImageButtonTouched() {
        addImageButtonOutputSubject.send(true)
    }
}
