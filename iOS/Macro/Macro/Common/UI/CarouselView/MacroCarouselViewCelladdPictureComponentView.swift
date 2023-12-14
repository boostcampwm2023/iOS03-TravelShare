//
//  MacroCarouselViewCelladdPictureComponentView.swift
//
//
//  Created by Byeon jinha on 12/3/23.
//

import UIKit

class MacroCarouselViewCellComponentView: UIView {
    
    // MARK: - UI Components
    
    private let addPictureLabel: UILabel = {
        let label = UILabel()
        label.text = Label.addPictureLabelText
        label.textColor = UIColor.appColor(.purple4)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let addPictureImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.appImage(.photo)
        imageView.tintColor = UIColor.appColor(.purple4)
        imageView.image = image
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings

extension MacroCarouselViewCellComponentView {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        addPictureLabel.translatesAutoresizingMaskIntoConstraints = false
        addPictureImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        self.addSubview(addPictureLabel)
        self.addSubview(addPictureImage)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            addPictureLabel.topAnchor.constraint(equalTo: self.topAnchor),
            addPictureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            addPictureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            addPictureImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addPictureImage.leadingAnchor.constraint(equalTo: addPictureLabel.trailingAnchor, constant: Padding.addPictureImageTrailing)
        ])
    }
    
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - LayoutMetrics

extension MacroCarouselViewCellComponentView {
    
    enum Padding {
        static let addPictureImageTrailing: CGFloat = 10
    }
    
    enum Label {
        static let addPictureLabelText: String = "사진 추가"
    }
}
