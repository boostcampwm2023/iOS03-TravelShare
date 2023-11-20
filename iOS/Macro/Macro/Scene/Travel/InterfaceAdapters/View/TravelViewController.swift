//
//  TravelViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Combine
import MacroDesignSystem
import NMapsMap
import UIKit

protocol RouteTableViewControllerDelegate: AnyObject {
    func routeTableViewDidDragChange(heightChange: CGFloat)
}

final class TravelViewController: UIViewController, RouteTableViewControllerDelegate, CLLocationManagerDelegate {
  
  // MARK: - Properties
  
  private let minimizedHeight: CGFloat = 200
  private let maximizedHeight: CGFloat = UIScreen.main.bounds.height - 200
  private var isModalViewExpanded = false
  private var routeTableViewHeightConstraint: NSLayoutConstraint?
  private var cancellables = Set<AnyCancellable>()
  private let inputSubject: PassthroughSubject<TravelViewModel.Input, Never> = .init()
  private let viewModel: TravelViewModel
  private var routeOverlay: NMFPolylineOverlay?
  private let locationManager = CLLocationManager()
  private let routeTableViewController: RouteTableViewController
  private var isTraveling = false {
    didSet {
      updateTravelButton()
    }
  }
  // MARK: - UI Components
  
  private let mapView: NMFMapView = {
    let mapView = NMFMapView()
    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.positionMode = .normal
    return mapView
  }()
  
  private let searchBar: UITextField = {
    let textField = UITextField()
    textField.placeholder = "검색"
    textField.backgroundColor = UIColor.appColor(.purple1)
    textField.layer.cornerRadius = 10
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    let imageView = UIImageView(image: UIImage.appImage(.magnifyingglass))
    imageView.tintColor = .gray
    let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width + 10, height: imageView.frame.height))
    imageView.center = iconContainerView.center
    iconContainerView.addSubview(imageView)
    
    textField.leftView = iconContainerView
    textField.leftViewMode = .always
    
    return textField
  }()
  
  private let travelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor.appColor(.statusGreen)
    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
    button.setImage(UIImage.appImage(.playCircle)?.withConfiguration(symbolConfig), for: .normal)
    button.layer.cornerRadius = 30
    return button
  }()
  
  private var markers: [String: NMFMarker] = [:]
  
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
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  override func viewWillLayoutSubviews() {
    view.bringSubviewToFront(travelButton)
  }
  
  // MARK: - Init
  
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
  
  // MARK: - UI Settings
  
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
      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      searchBar.heightAnchor.constraint(equalToConstant: 40),
      travelButton.widthAnchor.constraint(equalToConstant: 60),
      travelButton.heightAnchor.constraint(equalToConstant: 60),
      travelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      travelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
  private func setupRouteTableViewController() {
    addChild(routeTableViewController)
    view.addSubview(routeTableViewController.view)
    routeTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
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
  
  // MARK: - Bind
  
  private func bind() {
    
    // MARK: - Output Binding
    
    let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
    
    outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
      switch output {
      case .exchangeCell:
        self?.tempMethod()
      case .exchangeLocation:
        self?.tempMethod()
      case let .updateSearchResult(locationDetails):
        self?.getSearchResult(locationDetails)
      case let .addPinnedPlaceInMap(locationDetail):
        self?.addMarker(for: locationDetail)
      case let .removePinnedPlaceInMap(locationDetail):
        self?.removeMarker(for: locationDetail)
      case let .updateRoute(location):
        self?.updateMapWithLocation(location)
      case let .updateMarkers(pinnedPlaces):
        self?.updateMarkers(pinnedPlaces)
      default: break
      }
    }.store(in: &cancellables)
    
  }
  
  // MARK: - Methods
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude))
      cameraUpdate.animation = .easeIn
      mapView.moveCamera(cameraUpdate)
      locationManager.stopUpdatingLocation()
    }
  }
  
  private func updateMapWithLocation(_ routePoints: [CLLocation]) {
    routeOverlay?.mapView = nil
    let coords = routePoints.map { NMGLatLng(lat: $0.coordinate.latitude, lng: $0.coordinate.longitude) }
    routeOverlay = NMFPolylineOverlay(coords)
    routeOverlay?.mapView = mapView
  }
  
  private func addMarker(for locationDetail: LocationDetail) {
    let marker = NMFMarker()
    let position = NMGLatLng(lat: Double(locationDetail.mapy) ?? 0.0, lng: Double(locationDetail.mapx) ?? 0.0 )
    marker.position = position
    marker.mapView = mapView
    markers[locationDetail.placeName] = marker
    
    let cameraUpdate = NMFCameraUpdate(scrollTo: position)
    cameraUpdate.animation = .easeIn
    mapView.moveCamera(cameraUpdate)
    updateMarkers()
  }
  
  private func removeMarker(for locationDetail: LocationDetail) {
    if let marker = markers[locationDetail.placeName] {
      marker.mapView = nil
      markers.removeValue(forKey: locationDetail.placeName)
    }
    updateMarkers()
  }
  
  private func updateMarkers() {
    markers.values.forEach { $0.mapView = nil }
    markers.removeAll()
    
    for (index, place) in viewModel.savedRoute.pinnedPlaces.enumerated() {
      let marker = NMFMarker()
      marker.position = NMGLatLng(lat: Double(place.mapy) ?? 0.0, lng: Double(place.mapx) ?? 0.0 )
      marker.captionText = "\(index + 1). \(place.placeName)"
      marker.mapView = mapView
      markers[place.placeName] = marker
    }
  }
  private func updateMarkers(_ pinnedPlaces: [LocationDetail]) {
    markers.values.forEach { $0.mapView = nil }
    markers.removeAll()
    
    for (index, place) in pinnedPlaces.enumerated() {
      let marker = NMFMarker()
      marker.position = NMGLatLng(lat: Double(place.mapy) ?? 0.0, lng: Double(place.mapx) ?? 0.0)
      marker.captionText = "\(index + 1). \(place.placeName)"
      marker.mapView = mapView
      markers[place.placeName] = marker
    }
  }
  
  private func updateTravelButton() {
    if isTraveling {
      let symbolConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
      travelButton.setImage(UIImage.appImage(.pauseCircle)?.withConfiguration(symbolConfig), for: .normal)
      travelButton.tintColor = UIColor.appColor(.green4)
      travelButton.removeTarget(self, action: #selector(travelButtonTapped), for: .touchUpInside)
      travelButton.addTarget(self, action: #selector(endTravelButtonTapped), for: .touchUpInside)
    } else {
      travelButton.backgroundColor = UIColor.appColor(.statusGreen)
      travelButton.layer.borderColor = UIColor.appColor(.green3).cgColor
      travelButton.layer.borderWidth = 2
      let symbolConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
      travelButton.setImage(UIImage.appImage(.playCircle)?.withConfiguration(symbolConfig), for: .normal)
      travelButton.tintColor = UIColor.appColor(.green4)
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
  
  private func getSearchResult(_ locationDetails: [LocationDetail]) {
    let searchResultVC = SearchResultViewController(viewModel: viewModel)
    navigationController?.pushViewController(searchResultVC, animated: true)
  }
  
  @objc private func searchBarReturnPressed() {
    let text = searchBar.text ?? ""
    inputSubject.send(.searchLocation(text))
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
