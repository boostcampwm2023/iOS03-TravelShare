//
//  CAGradientLayer+.swift
//  
//
//  Created by Byeon jinha on 11/14/23.
//

import QuartzCore
import UIKit.UIColor

public extension CAGradientLayer {
    static func createGradientLayer(top: UIColor, bottom: UIColor, bounds: CGRect) -> CAGradientLayer {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        return gradientLayer
    }
    
    static func createGradientImageLayer(top: UIColor, bottom: UIColor, frame: CGRect, image: UIImage) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        let mask = CALayer()
        mask.contents = image.cgImage
        mask.frame = gradientLayer.bounds
        gradientLayer.mask = mask
        return gradientLayer
    }
}
