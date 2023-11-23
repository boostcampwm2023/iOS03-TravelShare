//
//  LocationManager.swift
//  Macro
//
//  Created by Byeon jinha on 11/23/23.
//

import Combine
import CoreLocation
import UIKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var timer: Timer?
    
    var locationPublisher = CurrentValueSubject<[CLLocation], Never>([])

    // MARK: - Init
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startUpdatingLocation()
        
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
    }

    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Methods
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationPublisher.value = locations
    }

    @objc private func updateLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
}
