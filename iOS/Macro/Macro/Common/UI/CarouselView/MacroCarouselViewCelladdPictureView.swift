//
//  MacroCarouselViewCellButtonView.swift
//  Macro
//
//  Created by Byeon jinha on 12/3/23.
//

import UIKit

class MacroCarouselViewCelladdPictureView: UIView {
    
    // MARK: - UI Components
    private let addPictureBackgroundView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.appColor(.purple1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let macroCarouselViewCellComponentView = MacroCarouselViewCellComponentView()
    
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

extension MacroCarouselViewCelladdPictureView {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        addPictureBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        macroCarouselViewCellComponentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        self.addSubview(addPictureBackgroundView)
        addPictureBackgroundView.addSubview(macroCarouselViewCellComponentView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            addPictureBackgroundView.widthAnchor.constraint(equalToConstant: UIScreen.width - 90),
            addPictureBackgroundView.heightAnchor.constraint(equalToConstant: UIScreen.width - 90),
            addPictureBackgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addPictureBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            macroCarouselViewCellComponentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            macroCarouselViewCellComponentView.widthAnchor.constraint(equalToConstant: 100),
            macroCarouselViewCellComponentView.heightAnchor.constraint(equalToConstant: 30),
            macroCarouselViewCellComponentView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}
