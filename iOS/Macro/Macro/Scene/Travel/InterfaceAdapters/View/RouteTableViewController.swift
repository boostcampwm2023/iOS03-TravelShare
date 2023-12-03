//
//  RouteTableViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/14/23.
//

import Combine
import UIKit

final class RouteTableViewController: UITableViewController {
  
  // MARK: - Properties
  
  weak var delegate: RouteTableViewControllerDelegate?
  private let dragIndicator = UIView()
  private var cancellables = Set<AnyCancellable>()
  var viewModel: TravelViewModel
  private let inputSubject: PassthroughSubject<TravelViewModel.Input, Never> = .init()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupDragIndicator()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.isEditing = true
    tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateDragIndicatorPosition()
  }
  
  // MARK: - Init
  
  init(viewModel: TravelViewModel) {
    self.viewModel = viewModel
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Bind

extension RouteTableViewController {
    
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

// MARK: - Methods

extension RouteTableViewController {
    
    private func updatePinnedPlaces(_ places: [LocationDetail]) {
      self.tableView.reloadData()
    }
    
    private func setupDragIndicator() {
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
      dragIndicator.frame = CGRect(x: (headerView.bounds.width / 2) - 20, y: 8, width: 40, height: 5)
      dragIndicator.backgroundColor = .systemGray4
      dragIndicator.layer.cornerRadius = 2.5
      dragIndicator.isUserInteractionEnabled = true
      
      let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragIndicatorPan(_:)))
      dragIndicator.addGestureRecognizer(panGesture)
      
      headerView.addSubview(dragIndicator)
      tableView.tableHeaderView = headerView
    }
    
    @objc private func handleDragIndicatorPan(_ gesture: UIPanGestureRecognizer) {
      let translation = gesture.translation(in: self.view)
      delegate?.routeTableViewDidDragChange(heightChange: translation.y)
      gesture.setTranslation(.zero, in: self.view)
    }
    
    private func updateDragIndicatorPosition() {
      dragIndicator.center.x = tableView.tableHeaderView?.bounds.midX ?? 0
    }
}

// MARK: - TableView

extension RouteTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.savedRoute.pinnedPlaces.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = viewModel.savedRoute.pinnedPlaces[indexPath.row].placeName
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    viewModel.movePinnedPlace(from: sourceIndexPath.row, to: destinationIndexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let locationDetail = viewModel.savedRoute.pinnedPlaces[indexPath.row]
      viewModel.removePinnedPlace(locationDetail)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40 
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = tableView.backgroundColor
    
    let headerLabel = UILabel()
    headerLabel.text = "경로"
    headerLabel.font = UIFont.systemFont(ofSize: 16)
    headerLabel.textColor = .black
    headerLabel.translatesAutoresizingMaskIntoConstraints = false
    headerView.addSubview(headerLabel)
    
    NSLayoutConstraint.activate([
      headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
      headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
      headerLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -50)
    ])
    
    return headerView
  }
}
