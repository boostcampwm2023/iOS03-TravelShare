//
//  TabBarOpacityView.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import UIKit

final class TabBarOpacityView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpLayout() {
        self.backgroundColor = UIColor.appColor(.opacity30)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: UIScreen.width),
            self.heightAnchor.constraint(equalToConstant: UIScreen.height)
        ])
    }
}
