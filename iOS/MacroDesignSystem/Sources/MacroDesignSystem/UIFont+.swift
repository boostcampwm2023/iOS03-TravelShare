//
//  UIFont+.swift
//  
//
//  Created by 김경호 on 11/13/23.
//

import UIKit.UIFont

public enum FontAsset {
    case baeEunLargeTitle
    case baeEunTitle1
    case baeEunBody
    case baeEunCallout
    case baeEunCaption
}

public extension UIFont {
    static func appFont(_ name: FontAsset) -> UIFont? {
        switch name {
        case .baeEunLargeTitle:
            return UIFont(name: "나눔손글씨 배은혜체", size: 40)
        case .baeEunTitle1:
            return UIFont(name: "나눔손글씨 배은혜체", size: 30)
        case .baeEunBody:
            return UIFont(name: "나눔손글씨 배은혜체", size: 25)
        case .baeEunCallout:
            return UIFont(name: "나눔손글씨 배은혜체", size: 22)
        case .baeEunCaption:
            return UIFont(name: "나눔손글씨 배은혜체", size: 18)
        }
    }
}
