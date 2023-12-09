//
//  TravelViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Combine
import MacroDesignSystem
import MacroNetwork
import NMapsMap
import UIKit

protocol RouteTableViewControllerDelegate: AnyObject {
    func routeTableViewDidDragChange(heightChange: CGFloat)
    func routeTableViewEndDragChange()
}

final class TravelViewController: TabViewController, RouteTableViewControllerDelegate {
    
    // MARK: - Properties
    private var routeTableViewHeightConstraint: NSLayoutConstraint?
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject: PassthroughSubject<TravelViewModel.Input, Never> = .init()
    private let viewModel: TravelViewModel
    private var polyline: NMFPolylineOverlay?
    private let routeTableViewController: RouteModalViewController
    private var isTraveling = false {
        didSet {
            updateTravelButton()
        }
    }
    // MARK: - UI Components
    
    lazy var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.positionMode = .normal
        return mapView
    }()
    
    private let searchBar: UITextField = CommonUIComponents.createSearchBar()
    
    private let travelButtonView: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 2
        button.clipsToBounds = true
        let gradientLayer: CAGradientLayer = CAGradientLayer.createGradientLayer(
            top: UIColor.appColor(.green1),
            bottom: UIColor.appColor(.green2),
            bounds: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        button.layer.borderColor = UIColor.appColor(.green4).cgColor
        
        return button
    }()
    
    private let myLocationButtonView: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 2
        button.clipsToBounds = true
        let gradientLayer: CAGradientLayer = CAGradientLayer.createGradientLayer(
            top: UIColor.appColor(.blue1),
            bottom: UIColor.appColor(.blue2),
            bounds: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        button.layer.borderColor = UIColor.appColor(.blue4 ).cgColor
        
        return button
    }()
    
    private var markers: [LocationDetail: NMFMarker] = [:]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        setUpConstraints()
        setupRouteTableViewController()
        bind()
        updateTravelButton()
        updateMyLocationButton()
        searchBar.addTarget(self, action: #selector(searchBarReturnPressed), for: .editingDidEndOnExit)
        hideKeyboardWhenTappedAround()
      //  waitForValidLocation()
    }
    
    override func viewWillLayoutSubviews() {
        view.bringSubviewToFront(travelButtonView)
        view.bringSubviewToFront(myLocationButtonView)
    }
    
    // MARK: - Init
    
    init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
        self.routeTableViewController = RouteModalViewController(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

extension TravelViewController {
    
    private func setUpLayouts() {
        view.addSubview(mapView)
        view.addSubview(searchBar)
        view.addSubview(travelButtonView)
        view.addSubview(myLocationButtonView)
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
            
            travelButtonView.widthAnchor.constraint(equalToConstant: 60),
            travelButtonView.heightAnchor.constraint(equalToConstant: 60),
            travelButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            travelButtonView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            
            myLocationButtonView.widthAnchor.constraint(equalToConstant: 60),
            myLocationButtonView.heightAnchor.constraint(equalToConstant: 60),
            myLocationButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myLocationButtonView.topAnchor.constraint(equalTo: travelButtonView.bottomAnchor, constant: 10)
        ])
    }
    
    private func setupRouteTableViewController() {
        
        addChild(routeTableViewController)
        
        view.addSubview(routeTableViewController.view)
        routeTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        routeTableViewController.didMove(toParent: self)
        routeTableViewController.delegate = self
        routeTableViewHeightConstraint = routeTableViewController.view.heightAnchor.constraint(equalToConstant: ModalViewSize.minimumSize.sizeValue)
        
        NSLayoutConstraint.activate([
            routeTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            routeTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            routeTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            routeTableViewHeightConstraint!
        ])
    }
    
    private func generateTravelButtonImageView(isTravling: Bool) -> UIImageView {
        
        var image: UIImage?
        if isTravling {
            image = UIImage.appImage(.stopCircle)
        } else {
            image = UIImage.appImage(.playCircle)
            
        }
        
        let gradientLayerFrame = CGRect(x: 0,
                                        y: 0,
                                        width: 30,
                                        height: 30)
        
        let gradientLayer = CAGradientLayer.createGradientImageLayer(top: UIColor.appColor(.green3),
                                                                     bottom: UIColor.appColor(.green4),
                                                                     frame: gradientLayerFrame,
                                                                     image: image)
        
        let travelImageView: UIImageView = UIImageView(image: image)
        travelImageView.layer.addSublayer(gradientLayer)
        travelImageView.tintColor = .clear
        
        return travelImageView
    }
    
    private func updateTravelButton() {
        
        let travelImageView = generateTravelButtonImageView(isTravling: isTraveling)
        for subview in travelButtonView.subviews {
            subview.removeFromSuperview()
        }
        travelButtonView.addSubview(travelImageView)
        travelImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            travelImageView.widthAnchor.constraint(equalToConstant: 30),
            travelImageView.heightAnchor.constraint(equalToConstant: 30),
            travelImageView.centerXAnchor.constraint(equalTo: travelButtonView.centerXAnchor),
            travelImageView.centerYAnchor.constraint(equalTo: travelButtonView.centerYAnchor)
        ])
        let travelTapGesture = UITapGestureRecognizer(target: self, action: #selector(travelButtonTapped(_:)))
        let endTravelTapGesture = UITapGestureRecognizer(target: self, action: #selector(endTravelButtonTapped(_:)))
        if isTraveling {
            travelButtonView.addGestureRecognizer(endTravelTapGesture)
            travelButtonView.removeGestureRecognizer(travelTapGesture)
        } else {
            travelButtonView.addGestureRecognizer(travelTapGesture)
            travelButtonView.removeGestureRecognizer(endTravelTapGesture)
        }
    }
    
    func updateMyLocationButton() {
        let locationImage = UIImage.appImage(.scope)?.withRenderingMode(.alwaysTemplate)
        let locationImageView = UIImageView(image: locationImage)
        
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        myLocationButtonView.addSubview(locationImageView)
        
        NSLayoutConstraint.activate([
            locationImageView.widthAnchor.constraint(equalToConstant: 35),
            locationImageView.heightAnchor.constraint(equalToConstant: 30),
            locationImageView.centerXAnchor.constraint(equalTo: myLocationButtonView.centerXAnchor),
            locationImageView.centerYAnchor.constraint(equalTo: myLocationButtonView.centerYAnchor)
        ])
        
        locationImageView.tintColor = UIColor.appColor(.blue5)
        
        let myLocationTapGesture = UITapGestureRecognizer(target: self, action: #selector(myLocationButtonTapped(_:)))
        myLocationButtonView.addGestureRecognizer(myLocationTapGesture)
    }
}

// MARK: - Bind

extension TravelViewController {
    
    private func bind() {
        
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
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
            case let .showLocationInfo(locationDetail):
                self?.showLocationInfo(locationDetail)
            default: break
            }
        }.store(in: &cancellables)
        
    }
}

// MARK: - Methods

extension TravelViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        }
    }
    
    private func updateMapWithLocation(_ newLocation: CLLocation) {
        let newCoord = NMGLatLng(lat: newLocation.coordinate.latitude, lng: newLocation.coordinate.longitude)
        if polyline == nil {
            polyline = NMFPolylineOverlay([newCoord, newCoord])
            polyline?.mapView = mapView
        } else {
            guard let line = polyline?.line else { return }
            line.addPoint(newCoord)
            polyline?.line = line
            polyline?.mapView = mapView
        }
    }
    
    private func addMarker(for locationDetail: LocationDetail) {
        let marker = NMFMarker()
        let position = NMGLatLng(lat: Double(locationDetail.mapy) ?? 0.0, lng: Double(locationDetail.mapx) ?? 0.0 )
        marker.position = position
        marker.mapView = mapView
        markers[locationDetail] = marker
        marker.touchHandler = { [weak self] _ in
            self?.handleMarkerTap(marker)
            return true
        }
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
        updateMarkers()
    }
    
    private func removeMarker(for locationDetail: LocationDetail) {
        if let marker = markers[locationDetail] {
            marker.mapView = nil
            markers.removeValue(forKey: locationDetail)
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
            markers[place] = marker
            marker.touchHandler = { [weak self] _ in
                self?.handleMarkerTap(marker)
                return true
            }
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
            markers[place] = marker
        }
    }
    
    @objc private func travelButtonTapped(_ sender: UITapGestureRecognizer) {
        inputSubject.send(.startTravel)
        isTraveling = true
    }
    
    @objc private func endTravelButtonTapped(_ sender: UITapGestureRecognizer) {
        if viewModel.savedRoute.routePoints.isEmpty {
            requireMoreLocation()
            return
        }
        
        inputSubject.send(.endTravel)
        isTraveling = false
    }
    
    private func requireMoreLocation() {
        AlertBuilder(viewController: self)
            .setTitle("경로")
            .setMessage("이동하신 경로가 너무 짧습니다. 5초 이상 기록해주세요.")
            .addActionCancel("확인") {
            }
            .show()
    }
    
    @objc private func myLocationButtonTapped(_ sender: UITapGestureRecognizer) {
       moveCamera()
    }
    
    private func moveCamera() {
        guard let currentLocation = LocationManager.shared.sendLocation else { return }
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude))
          cameraUpdate.animation = .easeIn
          mapView.moveCamera(cameraUpdate)
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
    
    func routeTableViewEndDragChange() {
        finalizeRouteTableViewPosition()
    }
    
    private func updateRouteTableViewPosition(_ deltaY: CGFloat) {
        if let heightConstraint = routeTableViewHeightConstraint {
            var newHeight = heightConstraint.constant - deltaY
            if newHeight < ModalViewSize.minimumSize.sizeValue {
                newHeight = ModalViewSize.minimumSize.sizeValue
            } else if newHeight > view.frame.height - ModalViewSize.minimumSize.sizeValue {
                newHeight = view.frame.height - ModalViewSize.minimumSize.sizeValue
            }
            heightConstraint.constant = newHeight
        }
    }
    
    private func finalizeRouteTableViewPosition() {
        guard let heightConstraint = routeTableViewHeightConstraint else { return }
        var closestSize: CGFloat = ModalViewSize.maxSize.sizeValue
        var chooseSize: CGFloat = ModalViewSize.maxSize.sizeValue
        
        for modalSize in ModalViewSize.allCases {
            let sizeValue = modalSize.sizeValue
            if closestSize > abs(sizeValue - heightConstraint.constant) {
                closestSize = abs(sizeValue - heightConstraint.constant)
                chooseSize = sizeValue
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            heightConstraint.constant = chooseSize
            self.view.layoutIfNeeded()
        }
    }
    
    private func mapView(_ mapView: NMFMapView, didTap mapObject: NMFOverlay) -> Bool {
        if let marker = mapObject as? NMFMarker, let locationDetail = markers.first(where: { $0.value == marker })?.key {
            inputSubject.send(.selectLocation(locationDetail))
            return true
        }
        return false
    }
    
    private func showLocationInfo(_ locationDetail: LocationDetail) {
        let searcher = Searcher(provider: APIProvider(session: URLSession.shared))
        let locationInfoVC = LocationInfoViewController(viewModel: LocationInfoViewModel(locationDetail: locationDetail, searcher: searcher))
        navigationController?.pushViewController(locationInfoVC, animated: true)
    }
    private func handleMarkerTap(_ marker: NMFMarker) {
        if let locationDetail = markers.first(where: { $0.value == marker })?.key {
            showLocationInfo(locationDetail)
        }
    }
}
