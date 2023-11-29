//
//  MapCollectionViewCellHeaderView.swift
//  Macro
//
//  Created by Byeon jinha on 11/29/23.
//

import Combine
import UIKit

final class MapCollectionViewCellHeaderView<T: MapCollectionViewProtocol>: UIView {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: T?
    var uuid: String?
    
    // MARK: - UI Components
    
    private let travelListImageView: UIImageView = {
        let image: UIImage? = UIImage.appImage(.listBulletIndent)
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        imageView.tintColor = UIColor.appColor(.purple5)
        return imageView
    }()
    
    private let travelListLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunCaption)
        label.text = "default"
        return label
    }()
    
    private let trashImageView: UIImageView = {
        let image: UIImage? = UIImage.appImage(.trash)
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        imageView.tintColor = UIColor.appColor(.purple5)
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Handle Gesture
    
    @objc private func trashImageViewTap(_ sender: UITapGestureRecognizer) {
        guard let uuid = self.uuid else { return }
        viewModel?.deleteTravel(uuid: uuid)
    }
    
}

// MARK: - UI Settings

private extension MapCollectionViewCellHeaderView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        travelListImageView.translatesAutoresizingMaskIntoConstraints = false
        travelListLabel.translatesAutoresizingMaskIntoConstraints = false
        trashImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.addSubview(travelListImageView)
        self.addSubview(travelListLabel)
        self.addSubview(trashImageView)
    }
    
    func setLayoutConstraints() {
        
        NSLayoutConstraint.activate([
            travelListImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            travelListImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            travelListLabel.leadingAnchor.constraint(equalTo: travelListImageView.trailingAnchor, constant: 10),
            travelListLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            travelListLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            trashImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            trashImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func addTapGesture() {
        trashImageView.isUserInteractionEnabled = true
        let trashImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(trashImageViewTap(_:)))
        trashImageView.addGestureRecognizer(trashImageViewTapGesture)
    }
    
}

// MARK: - Bind

extension MapCollectionViewCellHeaderView {
    func bind(viewModel: T) {
        self.viewModel = viewModel
    }
}

// MARK: - Method

extension MapCollectionViewCellHeaderView {
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        addTapGesture()
    }
    
    func configure(item: TravelInfo) {
        self.uuid = item.id
        guard let recordedPindedInfo = item.recordedPindedInfo else { return }
        var locationNameArray: [String] = []
        if recordedPindedInfo.isEmpty {
            self.travelListLabel.text = "-"
            return
        }
        
        for pin in recordedPindedInfo {
            if let locationName = pin.keys.first {
                locationNameArray.append(locationName)
            }
        }
        
        self.travelListLabel.text = locationNameArray.joined(separator: " > ")
    }
    
}
