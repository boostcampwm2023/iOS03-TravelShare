//
//  TabBarBackgroundLargeCirclceView.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import MacroDesignSystem
import UIKit

final class TabBarBackgroundLargeCirclceView: UIView, CircularViewProtocol {
    
    override init(frame: CGRect) {
        let frame: CGRect = CGRect(x: 0,
                                   y: 0,
                                   width: Metrics.width,
                                   height: Metrics.height)
        super.init(frame: frame)
        setUpLayout()
        makeCircular()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpLayout() {
        let gradientLayer: CAGradientLayer = CAGradientLayer.createGradientLayer(top: Color.topColor,
                                                                                 bottom: Color.bottomColor,
                                                                                 bounds: bounds)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.borderColor = UIColor.appColor(.purple2).cgColor
        self.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Metrics.width),
            self.heightAnchor.constraint(equalToConstant: Metrics.height)
        ])
    }
}

// MARK: - Properties
extension TabBarBackgroundLargeCirclceView {
    enum Metrics {
        static let width: CGFloat = 280
        static let height: CGFloat = 280
    }
    
    enum Color {
        static let topColor = UIColor.appColor(.blue1)
        static let bottomColor = UIColor.appColor(.purple2)
    }
}
