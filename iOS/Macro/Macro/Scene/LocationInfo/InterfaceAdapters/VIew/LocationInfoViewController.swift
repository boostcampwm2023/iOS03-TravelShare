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
    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let categoryGroupLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let horizonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
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
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizonStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func addsubviews() {
        view.addSubview(horizonStackView)
        view.addSubview(verticalStackView)
        [categoryNameLabel, categoryGroupLabel].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        [placeNameLabel, addressLabel, verticalStackView, phoneLabel].forEach {
            horizonStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            verticalStackView.heightAnchor.constraint(equalToConstant: 40)
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
        print(model)
        placeNameLabel.text = model.placeName
        addressLabel.text = model.addressName
        categoryNameLabel.text = model.categoryName
        categoryGroupLabel.text = model.categoryGroupName
        phoneLabel.text = model.phone
    }
}

// MARK: - LayoutMetrics

extension LocationInfoViewController {
    
}
