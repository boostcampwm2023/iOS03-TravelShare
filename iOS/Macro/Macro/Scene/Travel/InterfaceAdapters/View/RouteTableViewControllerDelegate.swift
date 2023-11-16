//
//  RouteTableViewControllerDelegate.swift
//  Macro
//
//  Created by 김나훈 on 11/14/23.
//

import Foundation

protocol RouteTableViewControllerDelegate: AnyObject {
    func routeTableViewDidDragChange(heightChange: CGFloat)
}
