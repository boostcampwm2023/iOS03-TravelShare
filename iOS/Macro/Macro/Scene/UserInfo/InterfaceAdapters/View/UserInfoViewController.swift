//
//  UserInfoViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Foundation

final class UserInfoViewController: TabViewController {
    let viewModel: UserInfoViewModel
    
    init(viewModel: UserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
