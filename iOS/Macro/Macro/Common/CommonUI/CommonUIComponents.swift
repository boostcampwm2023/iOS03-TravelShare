//
//  CommonUIComponents.swift
//  Macro
//
//  Created by 김나훈 on 11/21/23.
//

import UIKit

final class CommonUIComponents {
    
    static func createSearchBar() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "검색"
        textField.backgroundColor = UIColor.appColor(.purple1)
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: UIImage.appImage(.magnifyingglass))
        imageView.tintColor = .gray
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width + 10, height: imageView.frame.height))
        imageView.center = iconContainerView.center
        iconContainerView.addSubview(imageView)
        textField.leftView = iconContainerView
        textField.leftViewMode = .always
        return textField
    }
    
}
