//
//  PostContentDelegate.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import Foundation
import UIKit

protocol PostCollectionViewDelegate: AnyObject {
    func didTapContent(viewController: ReadViewController)
    func didTapProfile(viewController: UserInfoViewController)
}

class TouchableViewController: UIViewController { }

extension TouchableViewController: PostCollectionViewDelegate {
    
    func didTapContent(viewController: ReadViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didTapProfile(viewController: UserInfoViewController) {
        if navigationController?.viewControllers.contains(where: { $0 is UserInfoViewController }) == true {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
