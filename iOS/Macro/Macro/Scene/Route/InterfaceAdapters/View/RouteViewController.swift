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
    private var tabBarOutputSubject: PassthroughSubject<TabBarViewModel.Output, Never>
    
    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 여행"
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.textColor = UIColor.appColor(.blue2)
        return label
    }()
    
    lazy var dataEmptyView: DataEmptyView = DataEmptyView(
        emptyTitle: "여행 정보가 없습니다.",
        addActionConfirm: ConfirmAction(
            text: "여행 하러 가기",
            action: {
                self.transView(.travel)
            }
        )
    )
    
    let viewModel: RouteViewModel
    lazy var routeCollectionView: MapCollectionView = MapCollectionView(frame: .zero, viewModel: viewModel)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        setupLayout()
        bind()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchLocalTravels()
        super.viewWillAppear(animated)
    }
    
    // MARK: - Init
    init(viewModel: RouteViewModel, tabBarOutputSubject: PassthroughSubject<TabBarViewModel.Output, Never>) {
        self.viewModel = viewModel
        self.tabBarOutputSubject = tabBarOutputSubject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings
private extension RouteViewController {
    func setTranslatesAutoresizingMaskIntoConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        routeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dataEmptyView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(routeCollectionView)
        self.view.addSubview(dataEmptyView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            routeCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            routeCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            routeCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            routeCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            dataEmptyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            dataEmptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            dataEmptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            dataEmptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
            case let .navigateToWriteView(viewModel):
                self?.navigateToWriteView(viewModel: viewModel)
            case let .transView(changeTabbarType):
                self?.transView(changeTabbarType)
            case let .changeInnerView(isEmpty):
                self?.changeInnerView(isEmpty)
            }
        }.store(in: &cancellables)
    }
}

// MARK: - Methods
private extension RouteViewController {
    
    func changeInnerView(_ isRouteEmpty: Bool) {
            routeCollectionView.isHidden = isRouteEmpty
        dataEmptyView.isHidden = !isRouteEmpty
    }
    
    func transView(_ changeTabbarType: TabbarType) {
        tabBarOutputSubject.send(.changeTap(changeTabbarType))
    }
    
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
    
    func navigateToWriteView(viewModel: WriteViewModel) {
        let writeViewController = WriteViewController(viewModel: viewModel)
        navigationController?.pushViewController(writeViewController, animated: true)
    }
}
