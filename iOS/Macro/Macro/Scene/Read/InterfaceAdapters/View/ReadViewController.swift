//
//  ReadViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import UIKit

final class ReadViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: ReadViewModel
    
    // MARK: - UI Components
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    init(viewModel: ReadViewModel, postInfo: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.appColor(.blue1)
        label.text = postInfo
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ReadViewController {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.view.addSubview(label)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
}
