//
//  LocationInfoViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import UIKit

final class LocationInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpLayout()
    }
    
    // MARK: - Init
    
}

// MARK: - UI Settings

extension LocationInfoViewController {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    private func addsubviews() {
        view.addSubview(label)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            label.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
}

extension LocationInfoViewController {
    
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - Bind

extension LocationInfoViewController {
    
}

// MARK: - Methods

extension LocationInfoViewController {
    func updateText(_ model: LocationDetail) {
        label.text = model.placeName
    }
}

// MARK: - LayoutMetrics

extension LocationInfoViewController {
    
}
