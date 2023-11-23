//
//  MacroCarouselViewCell.swift
//  Macro
//
//  Created by 김경호 on 11/22/23.
//

import UIKit

class MacroCarouselViewCell: UICollectionViewCell {
    static let id = "MacroCrouselViewCell"

    // MARK: UI
    private let myView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Initializer
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

        self.prepare(image: nil)
    }

    func prepare(image: UIImage?
    ) {
        self.myView.image = image
    }
}

private var randomColor: UIColor {
    UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
}
