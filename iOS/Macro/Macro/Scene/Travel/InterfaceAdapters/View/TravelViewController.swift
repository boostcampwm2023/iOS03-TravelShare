//
//  TravelViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Combine
import NMapsMap
import MacroDesignSystem
import UIKit

final class TravelViewController: UIViewController, RouteTableViewControllerDelegate, CLLocationManagerDelegate {
  
  // MARK: UI Components
  
  private let mapView: NMFMapView = {
    let mapView = NMFMapView()
    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.positionMode = .normal
    return mapView
  }()
  
  private let searchBar: UITextField = {
    let textField = UITextField()
    textField.placeholder = "🔍 검색"
    textField.backgroundColor = UIColor.appColor(.purple1)
    textField.layer.cornerRadius = 10
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let routeTableViewController: RouteTableViewController
  
  private let travelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 25
    button.setTitle("여행", for: .normal)
    return button
  }()
  
  // MARK: Properties
  
  private let minimizedHeight: CGFloat = 100
  private let maximizedHeight: CGFloat = UIScreen.main.bounds.height - 200
  private var isModalViewExpanded = false
  private var routeTableViewHeightConstraint: NSLayoutConstraint?
  private var cancellables = Set<AnyCancellable>()
  private let inputSubject: PassthroughSubject<TravelViewModel.Input, Never> = .init()
  private let viewModel: TravelViewModel
  private var routeOverlay: NMFPolylineOverlay?
  let locationManager = CLLocationManager()
  private var isTraveling = false {
    didSet {
      updateTravelButton()
    }
  }
  
  // MARK: Initialization
  
  init(viewModel: TravelViewModel) {
    self.viewModel = viewModel
    self.routeTableViewController = RouteTableViewController(viewModel: viewModel)
    super.init(nibName: nil, bundle: nil)
    searchBar.addTarget(self, action: #selector(searchBarReturnPressed), for: .editingDidEndOnExit)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    locationManager.requestWhenInUseAuthorization()
    setUpLayouts()
    setUpConstraints()
    setupRouteTableViewController()
    bind()
    updateTravelButton()
  }
  
  override func viewWillLayoutSubviews() {
    view.bringSubviewToFront(travelButton)
  }
  
  // MARK: Methods
  
  private func bind() {
    
    // MARK: Input Binding
    
    // MARK: Output Binding
    
    let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
    
    outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
      switch output {
      case .exchangeCell:
        self?.tempMethod()
      case .exchangeLocation:
        self?.tempMethod()
      case let .updateSearchResult(locationDetails):
        self?.getSearchResult(locationDetails)
      case let .addPinnedPlaceInMap(mapx, mapy):
        self?.addPinnedPlace(mapx: mapx, mapy: mapy)
      case let .updateRoute(location):
        self?.updateMapWithLocation(location)
      default: break
      }
    }.store(in: &cancellables)
    
  }
  
  private func updateMapWithLocation(_ routePoints: [CLLocation]) {
    routeOverlay?.mapView = nil
    let coords = routePoints.map { NMGLatLng(lat: $0.coordinate.latitude, lng: $0.coordinate.longitude) }
    routeOverlay = NMFPolylineOverlay(coords)
    routeOverlay?.mapView = mapView
  }
  
  private func updateTravelButton() {
    if isTraveling {
      travelButton.setTitle("종료", for: .normal)
      travelButton.backgroundColor = .systemCyan
      travelButton.removeTarget(self, action: #selector(travelButtonTapped), for: .touchUpInside)
      travelButton.addTarget(self, action: #selector(endTravelButtonTapped), for: .touchUpInside)
    } else {
      travelButton.setTitle("여행", for: .normal)
      travelButton.backgroundColor = .systemBlue
      travelButton.removeTarget(self, action: #selector(endTravelButtonTapped), for: .touchUpInside)
      travelButton.addTarget(self, action: #selector(travelButtonTapped), for: .touchUpInside)
    }
  }
  
  @objc private func travelButtonTapped() {
    inputSubject.send(.startTravel)
    isTraveling = true
  }
  
  @objc private func endTravelButtonTapped() {
    inputSubject.send(.endTravel)
    isTraveling = false
  }
  
  private func tempMethod() {
  }
  
  private func addPinnedPlace(mapx: Double, mapy: Double) {
    let marker = NMFMarker()
    marker.position = NMGLatLng(lat: mapy, lng: mapx)
    marker.mapView = mapView
  }
  
  private func getSearchResult(_ locationDetails: [LocationDetail]) {
    let searchResultVC = SearchResultViewController(locationDetails: locationDetails, viewModel: viewModel)
    navigationController?.pushViewController(searchResultVC, animated: true)
  }
  
  @objc private func searchBarReturnPressed() {
    let text = searchBar.text ?? ""
    inputSubject.send(.searchLocation(text))
  }
  
  private func setUpLayouts() {
    view.addSubview(mapView)
    view.addSubview(searchBar)
    view.addSubview(travelButton)
  }
  
  private func setUpConstraints() {
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      searchBar.heightAnchor.constraint(equalToConstant: 43)
    ])
    
    NSLayoutConstraint.activate([
      travelButton.widthAnchor.constraint(equalToConstant: 50),
      travelButton.heightAnchor.constraint(equalToConstant: 50),
      travelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      travelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
  private func setupRouteTableViewController() {
    addChild(routeTableViewController)
    view.addSubview(routeTableViewController.view)
    routeTableViewController.view.translatesAutoresizingMaskIntoConstraints = false // 이 부분을 추가합니다.
    routeTableViewController.didMove(toParent: self)
    routeTableViewController.delegate = self
    
    routeTableViewHeightConstraint = routeTableViewController.view.heightAnchor.constraint(equalToConstant: minimizedHeight)
    
    NSLayoutConstraint.activate([
      routeTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      routeTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      routeTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      routeTableViewHeightConstraint!
    ])
  }
  
  func routeTableViewDidDragChange(heightChange: CGFloat) {
    updateRouteTableViewPosition(heightChange)
  }
  
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .changed:
      let translation = gesture.translation(in: view)
      updateRouteTableViewPosition(translation.y)
      gesture.setTranslation(.zero, in: view)
    case .ended:
      finalizeRouteTableViewPosition()
    default:
      break
    }
  }
  
  private func updateRouteTableViewPosition(_ deltaY: CGFloat) {
    if let heightConstraint = routeTableViewHeightConstraint {
      var newHeight = heightConstraint.constant - deltaY
      if newHeight < minimizedHeight {
        newHeight = minimizedHeight
      } else if newHeight > view.frame.height - minimizedHeight {
        newHeight = view.frame.height - minimizedHeight
      }
      heightConstraint.constant = newHeight
    }
  }
  
  private func finalizeRouteTableViewPosition() {
    guard let heightConstraint = routeTableViewHeightConstraint else { return }
    
    let shouldExpand = heightConstraint.constant > (maximizedHeight / 2)
    let newHeight = shouldExpand ? maximizedHeight : minimizedHeight
    
    UIView.animate(withDuration: 0.3) {
      heightConstraint.constant = newHeight
      self.view.layoutIfNeeded()
    }
    isModalViewExpanded = shouldExpand
  }
}
