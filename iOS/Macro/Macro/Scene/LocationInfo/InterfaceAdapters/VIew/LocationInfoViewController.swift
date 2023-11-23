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

    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
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
    }
    private func addsubviews() {
        view.addSubview(verticalStackView)
        [placeNameLabel, addressLabel, categoryNameLabel, categoryGroupLabel, phoneLabel].forEach {
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
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
        placeNameLabel.text = "가게 정보: " + model.placeName
        addressLabel.text = "주소: " + model.addressName
        categoryNameLabel.text = "종류: " + model.categoryName
        categoryGroupLabel.text = "분류: " + model.categoryGroupName
        phoneLabel.text = "전화번호: " + (model.phone?.isEmpty == true ? "-" : (model.phone ?? "-"))
    }
}

// MARK: - LayoutMetrics

extension LocationInfoViewController {
    
}
