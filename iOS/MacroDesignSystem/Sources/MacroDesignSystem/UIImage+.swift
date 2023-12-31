//
//  UIImage+.swift
//
//
//  Created by Byeon jinha on 11/16/23.
//

import UIKit.UIImage

public enum ImageAsset {
    public enum SFSymbol {
        case magnifyingglass
        case house
        case personCircle
        case map
        case squareAndPencil
        case handThumbsup
        case handThumbsupFill
        case eyes
        case paperplane
        case lockFill
        case lockOpenFill
        case photo
        case person2Fill
        case chartBarDocHorizontal
        case pin
        case pinFill
        case mappin
        case playCircle
        case pauseCircle
        case trash
        case listBulletIndent
        case scope
        case stopCircle
        case location
        case exclamationmarkBubble
        case checkmarkCircle
        case checkmarkCircleFill
    }
    
    public enum CustomImage {
        case appLogo
        case internetDisconnectedImage
        case profileDefaultImage
        case disConnectWifi
        case emptyImage
    }
}

@available(iOS 13.0, *)
public extension UIImage {
    static func appImage(_ name: ImageAsset.SFSymbol) -> UIImage? {
        switch name {
        case .magnifyingglass:
            return UIImage(systemName: "magnifyingglass")
        case .house:
            return UIImage(systemName: "house")
        case .personCircle:
            return UIImage(systemName: "person.circle")
        case .map:
            return UIImage(systemName: "map")
        case .squareAndPencil:
            return UIImage(systemName: "square.and.pencil")
        case .handThumbsup:
            return UIImage(systemName: "hand.thumbsup")
        case .handThumbsupFill:
            return UIImage(systemName: "hand.thumbsup.fill")
        case .eyes:
            return UIImage(systemName: "eyes")
        case .paperplane:
            return UIImage(systemName: "paperplane")
        case .lockFill:
            return UIImage(systemName: "lock.fill")
        case .lockOpenFill:
            return UIImage(systemName: "lock.open.fill")
        case .photo:
            return UIImage(systemName: "photo")
        case .person2Fill:
            return UIImage(systemName: "person.2.fill")
        case .chartBarDocHorizontal:
            return UIImage(systemName: "chart.bar.doc.horizontal")
        case .pin:
            return UIImage(systemName: "pin")
        case .pinFill:
            return UIImage(systemName: "pin.fill")
        case .mappin:
            return UIImage(systemName: "mappin")
        case .playCircle:
            return UIImage(systemName: "play.circle")
        case .pauseCircle:
            return UIImage(systemName: "pause.circle")
        case .trash:
            return UIImage(systemName: "trash")
        case .listBulletIndent:
            return UIImage(systemName: "list.bullet.indent")
        case .scope:
            return UIImage(systemName: "scope")
        case .stopCircle:
            return UIImage(systemName: "stop.circle")
        case .location:
            return UIImage(systemName: "location")
        case .exclamationmarkBubble:
            return UIImage(systemName: "exclamationmark.bubble")
        case .checkmarkCircle:
            return UIImage(systemName: "checkmark.circle")
        case .checkmarkCircleFill:
            return UIImage(systemName: "checkmark.circle.fill")
        }
    }
    
    static func appImage(_ name: ImageAsset.CustomImage) -> UIImage? {
        switch name {
        case .appLogo:
            return UIImage(named: "LogoImage")
        case .internetDisconnectedImage:
            return UIImage(named: "InternetDisconnectedImage")
        case .profileDefaultImage:
            return UIImage(named: "ProfileDefaultImage")
        case .disConnectWifi:
            return UIImage(named: "DisConnectWifi")
        case .emptyImage:
            return UIImage(named: "EmptyImage")
        }
    }
}
