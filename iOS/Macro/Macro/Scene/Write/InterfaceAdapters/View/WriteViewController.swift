//
//  WriteViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Foundation

final class WriteViewController: TabViewController {
    let viewModel: WriteViewModel
    
    init(viewModel: WriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
