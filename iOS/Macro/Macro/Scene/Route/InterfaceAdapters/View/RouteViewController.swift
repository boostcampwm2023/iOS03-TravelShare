//
//  RouteViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/29/23.
//

import Combine
import UIKit

class RouteViewController: UIViewController {
    
    // MARK: - Properties
    private let inputSubject: PassthroughSubject<RouteViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 여행"
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.textColor = UIColor.appColor(.blue2)
        return label
    }()
    
    let viewModel: RouteViewModel
    lazy var routeCollectionView: MapCollectionView = MapCollectionView(frame: .zero, viewModel: viewModel)
    
    init(viewModel: RouteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupLayout()
        bind()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchLocalTravels()
        super.viewWillAppear(animated)
    }
}

// MARK: - UI Settings
private extension RouteViewController {
    func setTranslatesAutoresizingMaskIntoConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        routeCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(routeCollectionView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            routeCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            routeCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            routeCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            routeCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Bind

extension RouteViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .deleteTravel(uuid):
                self?.deleteTravel(uuid: uuid)
            case let .navigateToWriteView(travelInfo):
                self?.navigateToWriteView(travelInfo: travelInfo)
            default: break
            }
        }.store(in: &cancellables)
    }
}

// MARK: - Methods
private extension RouteViewController {
    
    func fetchLocalTravels() {
        do {
            try CoreDataManager.shared.fetchTravel { travels in
                if let travels = travels {
                    self.viewModel.travels = travels
                    self.routeCollectionView.reloadData()
                }
            }
        } catch {
        }
    }
    
    func deleteTravel(uuid: String) {
        CoreDataManager.shared.deleteTravel(travelUUID: uuid)
        fetchLocalTravels()
    }
    
    func navigateToWriteView(travelInfo: TravelInfo) {
        navigationController?.pushViewController(self.viewModel.writeViewController, animated: true)
    }
}
