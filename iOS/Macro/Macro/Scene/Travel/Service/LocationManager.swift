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
    
    lazy var locationPublisher = CurrentValueSubject<CLLocation?, Never>(sendLocation)

    // MARK: - Init
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
    }
    
    func stopRecording() {
        timer?.invalidate()
        timer = nil
        locationManager.allowsBackgroundLocationUpdates = false
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
