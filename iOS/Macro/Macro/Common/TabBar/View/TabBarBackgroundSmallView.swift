//
//  TabBarBackgroundSmallView.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import MacroDesignSystem
import UIKit

final class TabBarBackgroundSmallCirclceView: UIView, CircularViewProtocol {
    
    override init(frame: CGRect) {
        let frame: CGRect = CGRect(x: 0,
                                   y: 0,
                                   width: Metrics.width,
                                   height: Metrics.height)
        super.init(frame: frame)
    
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpLayout() {
        
        self.backgroundColor = Color.backgroundColor
        
        makeCircular()
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Metrics.width),
            self.heightAnchor.constraint(equalToConstant: Metrics.height)
        ])

    }
}

// MARK: - Properties
extension TabBarBackgroundSmallCirclceView {
    
    enum Metrics {
        static let width: CGFloat = 100
        static let height: CGFloat = 100
    }
    
    enum Color {
        static let backgroundColor = UIColor.appColor(.blue2)
    }
}
