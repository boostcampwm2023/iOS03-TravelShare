//
//  ModalViewSize.swift
//  Macro
//
//  Created by Byeon jinha on 12/6/23.
//

import UIKit.UIScreen

enum ModalViewSize: CaseIterable {
    case minimumSize
    case middleSize
    case maxSize
    
    var sizeValue: CGFloat {
        switch self {
        case .minimumSize:
            return 200
        case .middleSize:
            return UIScreen.height / 2 - 25
        case .maxSize:
            return UIScreen.height - 250
        }
    }
}
