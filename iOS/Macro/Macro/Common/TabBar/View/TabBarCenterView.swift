//
//  TabBarCenterView.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import UIKit

final class TabBarCenterView: UIView, CircularViewProtocol {
    
    let imageView: UIImageView = UIImageView()
    
    var image: UIImage = UIImage(systemName: "house") ?? UIImage() {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        let frame: CGRect = CGRect(x: 0,
                                   y: 0,
                                   width: Metrics.width,
                                   height: Metrics.height)
        
        super.init(frame: frame)
        
        makeCircular()
        
        let gradientLayer: CAGradientLayer = CAGradientLayer.createGradientLayer(
            top: Color.topColor,
            bottom: Color.bottomColor,
            bounds: self.bounds)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        self.layer.borderColor = UIColor.appColor(.purple2).cgColor
        self.layer.borderWidth = 2
        
        setUpLayout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMaskLayer()
    }
    
    private func setupTranslatesAutoresizingMaskIntoConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        self.addSubview(imageView)
        
        let gradientLayerFrame = CGRect(x: Metrics.width / 2 - Metrics.imageWidth / 2,
                                        y: Metrics.height / 2 - Metrics.imageHeight / 2,
                                        width: Metrics.imageWidth,
                                        height: Metrics.imageHeight)
        
        let gradientLayer = CAGradientLayer.createGradientImageLayer(top: Color.imageTopColor,
                                                                     bottom: Color.imageBottomColor,
                                                                     frame: gradientLayerFrame,
                                                                     image: image)
        imageView.layer.addSublayer(gradientLayer)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Metrics.width),
            self.heightAnchor.constraint(equalToConstant: Metrics.height),
            
            imageView.topAnchor.constraint(equalTo: super.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: super.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: super.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: super.trailingAnchor)
        ])
    }
    
    private func setConfigure() {
        imageView.tintColor = .clear
    }
    
    private func setUpLayout() {
        setupTranslatesAutoresizingMaskIntoConstraints()
        setConfigure()
        addSubviews()
        setLayoutConstraints()
    }
    
    private func updateMaskLayer() {
        guard let gradientLayer = imageView.layer.sublayers?.compactMap({ $0 as? CAGradientLayer }).first,
              let mask = gradientLayer.mask else { return }
        
        mask.contents = image.cgImage
    }
}

// MARK: - Properties
extension TabBarCenterView {
    
    enum Metrics {
        static let width: CGFloat = 60
        static let height: CGFloat = 60
        static let imageWidth: CGFloat = 22
        static let imageHeight: CGFloat = 22
    }
    
    enum Color {
        static let topColor = UIColor.appColor(.blue1)
        static let bottomColor = UIColor.appColor(.purple2)
        
        static let imageTopColor = UIColor.appColor(.purple2)
        static let imageBottomColor = UIColor.appColor(.purple5)
    }
}
