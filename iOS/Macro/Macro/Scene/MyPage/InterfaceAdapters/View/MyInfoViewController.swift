//
//  MyInformationViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/27/23.
//

import UIKit

final class MyInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: MyPageViewModel
    
    // MARK: - UI Components
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "임시"
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    // MARK: - Init
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings

private extension MyInfoViewController {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        view.addSubview(label)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
    func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - Binding

private extension MyInfoViewController {
    func bind() {
        
    }
}

// MARK: - Methods

private extension MyInfoViewController {
    func updateSearchResult(_ result: [PostFindResponse]) {
        
    }
}
