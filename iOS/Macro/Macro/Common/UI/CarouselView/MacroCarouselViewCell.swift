//
//  MacroCarouselViewCell.swift
//  Macro
//
//  Created by 김경호 on 11/22/23.
//

import UIKit

final class MacroCarouselViewCell: UICollectionViewCell {
    static let id = "MacroCrouselViewCell"

    // MARK: UI Components
    private let carouselImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.appColor(.blue2).cgColor
        return imageView
    }()

    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(self.carouselImageView)
        NSLayoutConstraint.activate([
            self.carouselImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.carouselImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.carouselImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.carouselImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(image: nil)
    }
    
    func prepare(image: UIImage?) {
        self.carouselImageView.image = image
    }
}
