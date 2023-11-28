//
//  LocationInfoViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import MacroDesignSystem
import UIKit

final class LocationInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.textColor = UIColor.appColor(.blue4)
        return label
    }()
    
    private let pinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunLargeTitle)
        let symbolImage = UIImage.appImage(.pinFill)?.withTintColor(UIColor.appColor(.purple3))
        let attachment = NSTextAttachment()
        attachment.image = symbolImage
        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString(string: " ")
        mutableAttributedString.append(attachmentString)
        label.attributedText = mutableAttributedString
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunTitle1)
        label.textColor = UIColor.appColor(.blue4)
        return label
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunBody)
        label.textColor = UIColor.appColor(.purple3)
        return label
    }()
    
    private let categoryGroupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunCaption)
        label.textColor = UIColor.appColor(.purple3)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunCallout)
        label.textColor = UIColor.appColor(.blue4)
        return label
    }()
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["포함된 여행", "함께 많이 간 장소"])
        control.selectedSegmentIndex = 0
        control.tintColor = UIColor.appColor(.purple2)
        let font = UIFont.appFont(.baeEunBody)
        let normalTextColor = UIColor.appColor(.purple5)
        control.setTitleTextAttributes([.font: font, .foregroundColor: normalTextColor], for: .normal)
        return control
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
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryGroupLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        pinLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
    }
    private func addsubviews() {
        view.addSubview(placeNameLabel)
        view.addSubview(addressLabel)
        view.addSubview(categoryNameLabel)
        view.addSubview(categoryGroupLabel)
        view.addSubview(phoneLabel)
        view.addSubview(pinLabel)
        view.addSubview(segmentControl)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            placeNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.nameTop),
            placeNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            addressLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: Padding.addressTop),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            categoryNameLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: Padding.categoryNameTop),
            categoryNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            categoryGroupLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: Padding.categoryGroupTop),
            categoryGroupLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            phoneLabel.topAnchor.constraint(equalTo: categoryGroupLabel.bottomAnchor, constant: Padding.phoneTop),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.labelSide),
            pinLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.pinSide),
            pinLabel.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: Padding.segmentTop)
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
        placeNameLabel.text = model.placeName.isEmpty == true ? "-" : model.placeName
        addressLabel.text = model.addressName.isEmpty == true ? "-" : model.addressName
        categoryNameLabel.text = model.categoryName.isEmpty == true ? "-" : model.categoryName
        categoryGroupLabel.text = model.categoryGroupName.isEmpty == true ? "-" : "(\(model.categoryGroupName))"
        phoneLabel.text = model.phone?.isEmpty == true ? "-" : (model.phone ?? "-")
    }
}
// MARK: - LayoutMetrics

extension LocationInfoViewController {
    enum Metrics {
        
    }
    enum Padding {
        static let nameTop: CGFloat = 20
        static let addressTop: CGFloat = 20
        static let categoryNameTop: CGFloat = 10
        static let categoryGroupTop: CGFloat = 0
        static let phoneTop: CGFloat = 10
        static let labelSide: CGFloat = 50
        static let pinSide: CGFloat = 28
        static let segmentTop: CGFloat = 18
    }
}
