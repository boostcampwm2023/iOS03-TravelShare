//
//  RelatedLocationCell.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import MacroDesignSystem
import UIKit

final class RelatedLocationCell: UICollectionViewCell {
    
    let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    let placeVisitedCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension RelatedLocationCell {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        placeVisitedCount.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        addSubview(placeNameLabel)
        addSubview(placeVisitedCount)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            placeNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Padding.LabelSide),
            placeNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            placeVisitedCount.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Padding.LabelSide),
            placeVisitedCount.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Methods

extension RelatedLocationCell {
    
    func configure(with location: RelatedLocation) {
        placeNameLabel.text = location.placeName
        placeVisitedCount.text = "\(location.postNum) 회"
    }
}

extension RelatedLocationCell {
    enum Padding {
        static let LabelSide: CGFloat = 30
    }
}
