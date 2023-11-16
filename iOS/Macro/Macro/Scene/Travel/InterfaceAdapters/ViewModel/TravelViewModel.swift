//
//  TravelViewModel.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Combine
import CoreLocation
import Foundation

final class TravelViewModel: ViewModelProtocol {
  
  // MARK: - Input
  
  enum Input {
    case startTravel
    case endTravel
    case searchLocation(String)
    case exchangeLocation
    case deleteLocation
    case addPinnedLocation(LocationDetail)
  }
  
  // MARK: - Output
  
  enum Output {
    case exchangeCell
    case exchangeLocation
    case updateSearchResult([LocationDetail])
    case updatePinnedPlaces([LocationDetail])
    case addPinnedPlaceInMap(Double, Double)
    case updateRoute([CLLocation])
  }
  
  // MARK: - Properties
  
  private let outputSubject = PassthroughSubject<Output, Never>()
  private let routeRecorder: RouteRecordUseCase
  private let locationSearcher: LocationSearchUseCase
  private let pinnedPlaceManager: PinnedPlaceManageUseCase
  private var cancellables = Set<AnyCancellable>()
  private var savedRoute: SavedRoute = SavedRoute()
  
  // MARK: - Init
  
  init(routeRecorder: RouteRecordUseCase, locationSearcher: LocationSearchUseCase, pinnedPlaceManager: PinnedPlaceManageUseCase) {
    self.routeRecorder = routeRecorder
    self.locationSearcher = locationSearcher
    self.pinnedPlaceManager = pinnedPlaceManager
  }
  
  // MARK: - Methods
  
  func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
    input.sink { [weak self] input in
      switch input {
      case .startTravel:
        self?.startRecord()
      case .endTravel:
        self?.stopRecord()
      case let .searchLocation(text):
        self?.searchPlace(with: text)
      case .exchangeLocation:
        self?.tempMethod()
      case .deleteLocation:
        self?.tempMethod()
      case let .addPinnedLocation(locationDetail):
        self?.addPinnedLocation(locationDetail: locationDetail)
      }
    }.store(in: &cancellables)
    
    return outputSubject.eraseToAnyPublisher()
  }
  
  func tempMethod() {
    print("temp")
  }
  
  private func addPinnedLocation(locationDetail: LocationDetail) {
    
    let newPinnedPlaces = pinnedPlaceManager.addPinnedLocation(locationDetail: locationDetail, to: savedRoute.pinnedPlaces)
    savedRoute.pinnedPlaces = newPinnedPlaces
    outputSubject.send(.updatePinnedPlaces(newPinnedPlaces))
    outputSubject.send(.addPinnedPlaceInMap(locationDetail.mapx, locationDetail.mapy))
  }
  
  private func startRecord() {
    routeRecorder.startRecording()
    routeRecorder.locationPublisher
      .sink { [weak self] location in
        self?.savedRoute.routePoints.append(location)
        self?.outputSubject.send(.updateRoute(self?.savedRoute.routePoints ?? []))
      }
      .store(in: &cancellables)
  }
  
  private func stopRecord() {
    routeRecorder.stopRecording()
  }
  
  private func searchPlace(with text: String) {
    locationSearcher.searchLocation(query: text).sink { completion in
      if case let .failure(error) = completion {
        print(error)
      }
    } receiveValue: { [weak self] response in
      self?.outputSubject.send(.updateSearchResult(response))
    }.store(in: &cancellables)
  }
  
}
