//
//  TabComponentView.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import UIKit

final class TabComponentView: UIView {
    var tabComponent: TabComponent! {
        didSet {
            setNeedsLayout()
        }
    }
    var index: Int!
    
    init(frame: CGRect, tabComponent: TabComponent, index: Int) {
        self.index = index
        self.tabComponent = tabComponent
        super.init(frame: frame)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    private func removeSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func setupLayout() {
        
        guard let image = UIImage(systemName: tabComponent.imageName) else { return }
        let imageView: UIImageView = {
            let imageView: UIImageView = UIImageView(image: image)
            imageView.tintColor = .clear
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
       
        let gradientLayerFrame = CGRect(x: 0,
                                        y: 0,
                                        width: Metrics.imageWidth,
                                        height: Metrics.imageHeight)
        
        let gradientLayer = CAGradientLayer.createGradientImageLayer(top: Color.imageTopColor,
                                                                     bottom: Color.imageBottomColor,
                                                                     frame: gradientLayerFrame,
                                                                     image: image)
        
        let imageLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = tabComponent.text
            label.textColor = UIColor.appColor(.purple4)
            label.font = UIFont.appFont(.baeEunCaption)
            return label
        }()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
        self.addSubview(imageLabel)
        imageView.layer.addSublayer(gradientLayer)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: super.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: super.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Metrics.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Metrics.imageHeight),

            imageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageLabel.centerXAnchor.constraint(equalTo: super.centerXAnchor)
        ])
    }
}

// MARK: - Properties
extension TabComponentView {
    enum Metrics {
        static let width: CGFloat = 60
        static let height: CGFloat = 60
        static let imageWidth: CGFloat = 28
        static let imageHeight: CGFloat = 28
    }
    
    enum Color {
        static let topColor = UIColor.appColor(.blue1)
        static let bottomColor = UIColor.appColor(.purple2)
        
        static let imageTopColor = UIColor.appColor(.purple2)
        static let imageBottomColor = UIColor.appColor(.purple5)
    }
}
