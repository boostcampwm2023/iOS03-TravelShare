//
//  MapCollectionViewCellContentView.swift
//  Macro
//
//  Created by Byeon jinha on 11/29/23.
//

import Combine
import NMapsMap
import UIKit

final class MapCollectionViewCellContentView<T: MapCollectionViewProtocol>: UIView {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var viewModel: T?
    var travelInfo: TravelInfo?
    private var routeOverlay: NMFPath?
    
    // MARK: - UI Components
    
    private let backGroundView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    private let opcityView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.appColor(.opacity30)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let title: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.blue1)
        label.font = UIFont.appFont(.baeEunTitle1)
        return label
    }()
    
    private let summary: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.appColor(.blue1)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.positionMode = .disabled
        return mapView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handle Gesture
    
    @objc private func contentTap(_ sender: UITapGestureRecognizer) {
        guard let travelInfo: TravelInfo = self.travelInfo else { return }
        viewModel?.navigateToWriteView(travelInfo: travelInfo)
    }
    
}

// MARK: - UI Settings

private extension MapCollectionViewCellContentView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        opcityView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.addSubview(backGroundView)
        backGroundView.addSubview(mapView)
        backGroundView.addSubview(opcityView)
        backGroundView.addSubview(title)
    }
    
    func setLayoutConstraints() {
        
        NSLayoutConstraint.activate([
            backGroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            backGroundView.heightAnchor.constraint(equalToConstant: 200),
            backGroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            mapView.topAnchor.constraint(equalTo: backGroundView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: backGroundView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor),
            
            opcityView.topAnchor.constraint(equalTo: backGroundView.topAnchor),
            opcityView.bottomAnchor.constraint(equalTo: backGroundView.bottomAnchor),
            opcityView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor),
            opcityView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor),
            
            title.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: backGroundView.centerYAnchor)
        ])
    }
    
    func addTapGesture() {
        backGroundView.isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentTap(_:)))
        backGroundView.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - Bind

extension MapCollectionViewCellContentView {
    
    func bind(viewModel: T) {
        self.viewModel = viewModel
    }
    
}
// MARK: - Methods

extension MapCollectionViewCellContentView {
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        addTapGesture()
    }
    
    func configure(item: TravelInfo) {
        self.travelInfo = item
        
        guard let start = item.startAt, let end = item.endAt else { return }
        self.title.text = "\(Date.transDate(start)) ~ \(Date.transDate(end))"
        
        guard let recordedLocation = item.recordedLocation else { return }
        calculateCenterLocation(routePoints: recordedLocation)
        updateMapWithLocation(routePoints: recordedLocation)
        
        guard let recordedPinnedInfo = item.recordedPinnedLocations else { return }
        
        updateMark(recordedPindedInfo: recordedPinnedInfo)
    }
    
    /// Center 좌표를 센터값을 구하고, 좌표간 거리를 기반으로 Zoom Level을 설정합니다.
    /// - Parameters:
    ///   - routePoints: 위도, 경도 배열 입니다.
    func calculateCenterLocation(routePoints: [[Double]]) {
        var maxLatitude = -90.0
        var minLatitude = 90.0
        var maxLongitude = -180.0
        var minLongitude = 180.0
        
        for point in routePoints {
            let latitude = point[0]
            let longitude = point[1]
            
            if latitude > maxLatitude {
                maxLatitude = latitude
            }
            if latitude < minLatitude {
                minLatitude = latitude
            }
            if longitude > maxLongitude {
                maxLongitude = longitude
            }
            if longitude < minLongitude {
                minLongitude = longitude
            }
        }
        
        let centerLatitude = (maxLatitude + minLatitude) / 2.0
        let centerLongitude = (maxLongitude + minLongitude) / 2.0
        
        let centerLocation = NMGLatLng(lat: centerLatitude, lng: centerLongitude)
        let distanceLatitude = abs(maxLatitude - minLatitude)
        let distanceLongitude = abs(maxLongitude - minLongitude)
        
        let zoomLevelLatitude = log2(90 / distanceLatitude)
        let zoomLevelLongitude = log2(90 / distanceLongitude)
        let zoomLevel = min(zoomLevelLatitude, zoomLevelLongitude)
        mapView.zoomLevel = zoomLevel
       
        let cameraUpdate = NMFCameraUpdate(scrollTo: centerLocation )
        mapView.moveCamera(cameraUpdate)
    }
    
    /// 이동 경로를 입력받아 지도에 그립니다.
    /// - Parameters:
    ///   - routePoints: 위도, 경도 배열 입니다.
    func updateMapWithLocation(routePoints: [[Double]]) {
        routeOverlay?.mapView = nil
        let coords = routePoints.map { NMGLatLng(lat: $0[0], lng: $0[1]) }
        routeOverlay = NMFPath(points: coords)
        routeOverlay?.color = UIColor.appColor(.purple1)
        routeOverlay?.mapView = mapView
    }
    
    // TODO: - 위경도 좌표가 바뀌어 있어요. 다음 스프린트 때, 코어데이터 테이블 추가하면서 수정하도록하겠습니다. :)
    /// Pin이 저장된 곳에  Mark를 찍습니다.
    /// - Parameters:
    ///   - recordedPindedInfo: Pin의 위도, 경도 배열 입니다.
    func updateMark(recordedPindedInfo: [RecordedPinnedLocationInfomation]) {
        for (index, placeInfo) in recordedPindedInfo.enumerated() {
            let marker = NMFMarker()
            guard let name = placeInfo.placeName?.first, let placeLocation = placeInfo.coordinate else { return }
            marker.position = NMGLatLng(lat: placeLocation.latitude, lng: placeLocation.longitude)
            marker.captionText = "\(index + 1). \(name)"
            marker.mapView = mapView
        }
    }
}
