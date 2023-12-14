//
//  CircularViewProtocol.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import UIKit

protocol CircularViewProtocol: AnyObject {
    func makeCircular()
}

extension CircularViewProtocol where Self: UIView {
    func makeCircular() {
        self.layer.cornerRadius = frame.size.width / 2
        self.clipsToBounds = true
    }
}
