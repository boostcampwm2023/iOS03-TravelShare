//
//  RouteTableViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/14/23.
//

import Combine
import UIKit

final class RouteModalViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: RouteTableViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    var viewModel: TravelViewModel
    private let inputSubject: PassthroughSubject<TravelViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    private let customGrabberArea: UIView = {
        let view = UIView()
        return view
    }()
    
    private let grabber: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 2.5
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "경로"
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.textColor = UIColor.appColor(.blue5)
        return label
    }()
    
    let tableView: UITableView = UITableView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 20
        customGrabberArea.layer.cornerRadius = 20
        setupDragIndicator()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragIndicatorPan(_:)))
        customGrabberArea.addGestureRecognizer(panGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isEditing = true
        
        bind()
    }
    
    // MARK: - Init
    
    init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Bind

extension RouteModalViewController {
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .updatePinnedPlacesTableView(locationDetails):
                self?.updatePinnedPlaces(locationDetails)
            default: break
            }
        }.store(in: &cancellables)
    }
    
}

// MARK: - UI Settings

extension RouteModalViewController {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        customGrabberArea.translatesAutoresizingMaskIntoConstraints = false
        grabber.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        self.view.addSubview(customGrabberArea)
        customGrabberArea.addSubview(grabber)
        customGrabberArea.addSubview(headerLabel)
        self.view.addSubview(tableView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            customGrabberArea.topAnchor.constraint(equalTo: self.view.topAnchor),
            customGrabberArea.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            customGrabberArea.heightAnchor.constraint(equalToConstant: 70),
            
            grabber.widthAnchor.constraint(equalToConstant: 40),
            grabber.heightAnchor.constraint(equalToConstant: 5),
            grabber.centerXAnchor.constraint(equalTo: customGrabberArea.centerXAnchor),
            grabber.topAnchor.constraint(equalTo: customGrabberArea.topAnchor, constant: 20),
            
            headerLabel.bottomAnchor.constraint(equalTo: customGrabberArea.bottomAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: customGrabberArea.leadingAnchor, constant: 40),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            tableView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Methods

extension RouteModalViewController {
    
    private func updatePinnedPlaces(_ places: [LocationDetail]) {
        self.tableView.reloadData()
    }
    
    private func setupDragIndicator() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        
        tableView.tableHeaderView = headerView
    }
    
    @objc private func handleDragIndicatorPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        delegate?.routeTableViewDidDragChange(heightChange: translation.y)
        gesture.setTranslation(.zero, in: self.view)
        if gesture.state == .ended {
            delegate?.routeTableViewEndDragChange()
        }
    }
    
}

// MARK: - TableView Delegate

extension RouteModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedRoute.pinnedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.savedRoute.pinnedPlaces[indexPath.row].placeName
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.movePinnedPlace(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locationDetail = viewModel.savedRoute.pinnedPlaces[indexPath.row]
            viewModel.removePinnedPlace(locationDetail)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
