//
//  LocationManager.swift
//  Macro
//
//  Created by Byeon jinha on 11/23/23.
//

import UIKit
import Combine
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var locationPublisher = CurrentValueSubject<[CLLocation], Never>([])
    var timer: Timer?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startUpdatingLocation()
        
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationPublisher.value = locations
    }

    @objc func updateLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
}
