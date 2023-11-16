//
//  RouteRecorder.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Combine
import CoreLocation
import Foundation
import Network

protocol RouteRecordUseCase {
  
  var locationPublisher: PassthroughSubject<CLLocation, Never> { get }
  
  func startRecording()
  func stopRecording()
}

final class RouteRecorder: NSObject, RouteRecordUseCase, CLLocationManagerDelegate {
  
  // MARK: - Properties
  
  private let locationManager = CLLocationManager()
  var locationPublisher = PassthroughSubject<CLLocation, Never>()
  private let provider: Requestable
  private var locationUpdateTimer: Timer?
  private let updateInterval: TimeInterval = 3
  
  // MARK: - Init
  
  init(provider: Requestable) {
    self.provider = provider
    super.init()
    configureLocationManager()
  }
  
  // MARK: - Methods
  
  private func configureLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func startRecording() {
      locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
          print("Location update started")
          self?.locationManager.startUpdatingLocation()
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1초 후에 위치 업데이트 중지
              self?.locationManager.stopUpdatingLocation()
              print("Location update stopped")
          }
      }
  }
  
  func stopRecording() {
    locationUpdateTimer?.invalidate()
    locationManager.stopUpdatingLocation()
    // TODO: Upload route data to server if needed
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locations.forEach { location in
      print("New location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
      locationPublisher.send(location)
    }
  }
}
