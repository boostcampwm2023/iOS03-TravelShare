//
//  ReadViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Foundation

final class ReadViewController: TabViewController {
    let viewModel: ReadViewModel
    
    init(viewModel: ReadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
