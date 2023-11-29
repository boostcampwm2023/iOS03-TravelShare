//
//  MapCollectionViewCell.swift
//  Macro
//
//  Created by Byeon jinha on 11/29/23.
//

import UIKit

final class MapCollectionViewCell<T: MapCollectionViewProtocol>: UICollectionViewCell {
    
    // MARK: - UI Components
    let mapCollectionViewCellContentView: MapCollectionViewCellContentView = MapCollectionViewCellContentView<T>()
    let mapCollectionViewCellHeaderView: MapCollectionViewCellHeaderView = MapCollectionViewCellHeaderView<T>()
    
    // MARK: - Properties
    let identifier = "MapCollectionViewCell"
    var homeViewModel: T?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI Settings

private extension MapCollectionViewCell {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        mapCollectionViewCellContentView.translatesAutoresizingMaskIntoConstraints = false
        mapCollectionViewCellHeaderView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.addSubview(mapCollectionViewCellContentView)
        self.addSubview(mapCollectionViewCellHeaderView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            mapCollectionViewCellHeaderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mapCollectionViewCellHeaderView.heightAnchor.constraint(equalToConstant: 40),
            mapCollectionViewCellHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapCollectionViewCellHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            mapCollectionViewCellContentView.topAnchor.constraint(equalTo: mapCollectionViewCellHeaderView.bottomAnchor),
            mapCollectionViewCellContentView.heightAnchor.constraint(equalToConstant: 200),
            mapCollectionViewCellContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapCollectionViewCellContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func componentConfigure(item: TravelInfo, viewModel: T) {
        if mapCollectionViewCellContentView.viewModel == nil {
            mapCollectionViewCellContentView.setLayout()
            mapCollectionViewCellContentView.bind(viewModel: viewModel)
            }
        mapCollectionViewCellContentView.configure(item: item)
        if mapCollectionViewCellHeaderView.viewModel == nil {
            mapCollectionViewCellHeaderView.setLayout()
            mapCollectionViewCellHeaderView.bind(viewModel: viewModel)
           }
        mapCollectionViewCellHeaderView.configure(item: item)
    }
}

// MARK: - Methods

extension MapCollectionViewCell {
    
    func configure(item: TravelInfo, viewModel: T) {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        componentConfigure(item: item, viewModel: viewModel)
    }
}
