//
//  UIColor+.swift
//
//
//  Created by 김경호 on 11/13/23.
//

import UIKit.UIColor

public enum ColorAsset {
    public enum DefaultColor {
        case defaultBlack
        case defaultWhite
    }
    
    public enum PrimaryColor {
        case green1
        case green2
        case green3
        case green4
        case green5
        
        case blue1
        case blue2
        case blue3
        case blue4
        case blue5
        
        case purple1
        case purple2
        case purple3
        case purple4
        case purple5
        
        case red1
        case red2
        case red3
        case red4
        case red5
        
        case yellow1
        case yellow2
        case yellow3
        case yellow4
        case yellow5
    }
    
    public enum SecondaryColor {
        case statusRed
        case statusGreen
    }
    
    public enum SpecialColor {
        case opacity30
        case grabber
        case isInactive
    }
}

@available(iOS 13.0, *)
public extension UIColor {
    static func appColor(_ name: ColorAsset.DefaultColor) -> UIColor {
        switch name {
        case .defaultBlack: return UIColor(hexCode: "#242831")
        case .defaultWhite: return UIColor(hexCode: "#FDFCFC")
        }
    }
    
    static func appColor(_ name: ColorAsset.PrimaryColor) -> UIColor {
        switch name {
        case .green1: return UIColor(hexCode: "#C8FFBA")
        case .green2: return UIColor(hexCode: "#6ACFC9")
        case .green3: return UIColor(hexCode: "#26B6C6")
        case .green4: return UIColor(hexCode: "#55826B")
        case .green5: return UIColor(hexCode: "#244F39")
            
        case .blue1: return UIColor(hexCode: "#F7F8FC")
        case .blue2: return UIColor(hexCode: "#7D8CC9")
        case .blue3: return UIColor(hexCode: "#3F5196")
        case .blue4: return UIColor(hexCode: "#162563")
        case .blue5: return UIColor(hexCode: "#010B33")

        case .purple1: return UIColor(hexCode: "#EBE8FF")
        case .purple2: return UIColor(hexCode: "#958DCC")
        case .purple3: return UIColor(hexCode: "#553B99")
        case .purple4: return UIColor(hexCode: "#271E66")
        case .purple5: return UIColor(hexCode: "#0B0533")

        case .red1: return UIColor(hexCode: "#FFC4AF")
        case .red2: return UIColor(hexCode: "#FFB293")
        case .red3: return UIColor(hexCode: "#FF9660")
        case .red4: return UIColor(hexCode: "#FF7A46")
        case .red5: return UIColor(hexCode: "#FF572C")
            
        case .yellow1: return UIColor(hexCode: "#FEF2CF")
        case .yellow2: return UIColor(hexCode: "#FFE799")
        case .yellow3: return UIColor(hexCode: "#FFE063")
        case .yellow4: return UIColor(hexCode: "#FFE643")
        case .yellow5: return UIColor(hexCode: "#FFCF14")
        }
    }
    
    static func appColor(_ name: ColorAsset.SecondaryColor) -> UIColor {
        switch name {
        case .statusRed: return UIColor(hexCode: "#FFA5A5")
        case .statusGreen: return UIColor(hexCode: "#BAFFC9")
        }
    }
    
    static func appColor(_ name: ColorAsset.SpecialColor) -> UIColor {
        switch name {
        case .opacity30: return UIColor(hexCode: "#242831", alpha: 0.3)
        case .grabber: return UIColor(hexCode: "#C6C8CB")
        case .isInactive: return UIColor(hexCode: "C4C4C4")
        }
    }
}

@available(iOS 13.0, *)
extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hexCode)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double((rgb >> 0) & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

