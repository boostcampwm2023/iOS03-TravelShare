//
//  UIView+.swift
//  Macro
//
//  Created by 김나훈 on 12/7/23.
//

import UIKit

extension UIView {
    func isValidUrl(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
