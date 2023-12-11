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
    
    func showToast(message: String) {
        let toastView = ToastView(text: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.topAnchor.constraint(equalTo: self.topAnchor, constant: 200),
            toastView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastView.alpha = 0
        }, completion: {(_) in
            toastView.removeFromSuperview()
        })
    }
}
