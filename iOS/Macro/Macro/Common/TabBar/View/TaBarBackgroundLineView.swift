//
//  TaBarBackgroundLineView.swift
//  Macro
//
//  Created by Byeon jinha on 11/18/23.
//

import UIKit

final class TabBarBackgroundLineView: UIView {
    
    // MARK: - Properties
    
    private let colors: [CGColor] = [
        UIColor.appColor(.blue2).cgColor,
        UIColor.appColor(.purple1).cgColor,
        UIColor.appColor(.blue2).cgColor,
        UIColor.appColor(.purple1).cgColor
    ]

    private let changeColors: [CGColor] = [
        UIColor.appColor(.purple1).cgColor,
        UIColor.appColor(.blue2).cgColor,
        UIColor.appColor(.purple1).cgColor,
        UIColor.appColor(.blue2).cgColor
    ]
    
    private var gradientLayer: CAGradientLayer = CAGradientLayer()
    private var colorAnimation: CABasicAnimation = CABasicAnimation()
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path: UIBezierPath = generatePath()
        
        let shapeLayer: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = UIColor.black.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = Metrics.shapeLineWidth
            return layer
        }()

        self.gradientLayer = {
            let layer: CAGradientLayer = CAGradientLayer()
            layer.frame = bounds
            layer.colors = colors
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
            layer.mask = shapeLayer
            return layer
        }()
        
        self.colorAnimation = {
            let animation = CABasicAnimation(keyPath: ColorKey.colors)
            animation.toValue = changeColors
            animation.duration = 1
            animation.autoreverses = true
            animation.repeatCount = .infinity
            return animation
        }()
        
        layer.addSublayer(gradientLayer)
        addAnimation()
    }
}

// MARK: - Methods

extension TabBarBackgroundLineView {
    
    func addAnimation() {
        gradientLayer.add(colorAnimation, forKey: ColorKey.animaion)
    }
    
    func removeAnimation() {
        gradientLayer.removeAnimation(forKey: ColorKey.animaion)
    }
}

private extension TabBarBackgroundLineView {
    
    func generatePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: Metrics.shapeMinX, y: Metrics.shapeMinY))
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: Metrics.shapeMinY),
                    radius: Metrics.shapeRaius,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: false)
        
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: Metrics.shapeMinY),
                    radius: Metrics.shapeRaius,
                    startAngle: CGFloat(Double.pi / 2),
                    endAngle: 0,
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: Metrics.shapeMaxX, y: Metrics.shapeMinY))
        
        path.addLine(to: CGPoint(x: Metrics.shapeMaxX, y: Metrics.shapeMaxY))
        path.addLine(to: CGPoint(x: Metrics.shapeMinX, y: Metrics.shapeMaxY))
        path.close()
        
        UIColor.appColor(.purple1).setFill()
        path.fill()
        return path
    }
}

// MARK: - LayoutMetrics

extension TabBarBackgroundLineView {
    
    enum Metrics {
        static let shapeMinX: CGFloat = -10
        static let shapeMaxX: CGFloat = UIScreen.width + 10
        static let shapeMinY: CGFloat = 0
        static let shapeMaxY: CGFloat = 100
        static let shapeLineWidth: CGFloat = 10
        static let shapeRaius: CGFloat = 35
    }
    
    enum ColorKey {
        static let colors: String = "colors"
        static let animaion: String = "colorChangeAnimation"
    }

    enum Padding {
        static let homeHeaderViewTop: CGFloat = 50
        static let homeCollectionViewTop: CGFloat = 10
    }
}
