//
//  LocationManager.swift
//  Macro
//
//  Created by Byeon jinha on 11/23/23.
//

import Combine
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var timer: Timer?
    var sendLocation: CLLocation?
    let authorizationStatusSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    lazy var locationPublisher = CurrentValueSubject<CLLocation?, Never>(sendLocation)
    
    // MARK: - Init
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
    }
    
    func startRecording() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func stopRecording() {
        timer?.invalidate()
        timer = nil
        sendLocation = nil
        locationManager.allowsBackgroundLocationUpdates = false
        self.locationPublisher.value = nil
    }
    
    // MARK: - Methods
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        sendLocation = location
    }
    
    @objc private func updateLocation() {
        guard let location = sendLocation else { return }
        self.locationPublisher.value = location
    }
}

extension LocationManager {
    var currentAuthorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusSubject.send(status)
    }
}
