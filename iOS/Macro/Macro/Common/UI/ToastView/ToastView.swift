//
//  ToastView.swift
//  Macro
//
//  Created by Byeon jinha on 12/12/23.
//

import UIKit

class ToastView: UIView {
    init(text: String) {
        super.init(frame: .zero)
        
        self.layer.masksToBounds = false
        addLabel(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addLabel(text: String) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.font = UIFont.appFont(.baeEunTitle1)
        toastLabel.textAlignment = .center
        toastLabel.textColor = UIColor.appColor(.statusGreen)
        toastLabel.text = text
        toastLabel.backgroundColor = UIColor.appColor(.purple4)
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.topAnchor.constraint(equalTo: self.topAnchor),
            toastLabel.widthAnchor.constraint(equalToConstant: 220),
            toastLabel.heightAnchor.constraint(equalToConstant: 50),
            toastLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toastLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
