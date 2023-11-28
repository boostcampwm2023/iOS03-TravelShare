//
//  TravelViewModel.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Foundation
import MacroNetwork
import Combine
import CoreLocation

final class TravelViewModel: ViewModelProtocol {
    
    // MARK: - Input
    
    enum Input {
        case startTravel
        case endTravel
        case searchLocation(String)
        case exchangeLocation
        case deleteLocation
        case togglePinnedPlaces(LocationDetail)
        case selectLocation(LocationDetail)
    }
    
    // MARK: - Output
    
    enum Output {
        case exchangeCell
        case exchangeLocation
        case updateSearchResult([LocationDetail])
        case updatePinnedPlacesTableView([LocationDetail])
        case addPinnedPlaceInMap(LocationDetail)
        case removePinnedPlaceInMap(LocationDetail)
        case updateRoute([CLLocation])
        case updateMarkers([LocationDetail])
        case showLocationInfo(LocationDetail)
    }
    
    // MARK: - Properties
    
    private var locationManager: LocationManager?
    private var currentTravel: TravelInfo?
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let routeRecorder: RouteRecordUseCase
    private let locationSearcher: SearchUseCase
    private let pinnedPlaceManager: PinnedPlaceManageUseCase
    private var cancellables = Set<AnyCancellable>()
    private (set) var savedRoute: SavedRoute = SavedRoute()
    private (set) var searchedResult: [LocationDetail] = []
    private var searchPageNum = 1
    
    // MARK: - Init
    
    init(routeRecorder: RouteRecordUseCase, locationSearcher: SearchUseCase, pinnedPlaceManager: PinnedPlaceManageUseCase) {
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
            case let .togglePinnedPlaces(locationDetail):
                self?.togglePinnedPlaces(locationDetail)
            case let .selectLocation(locationDetail):
                self?.outputSubject.send(.showLocationInfo(locationDetail))
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    func tempMethod() {
        print("temp")
    }
    
    func togglePinnedPlaces(_ locationDetail: LocationDetail) {
        if savedRoute.pinnedPlaces.contains(where: { $0.placeName == locationDetail.placeName }) {
            removePinnedPlace(locationDetail)
        } else {
            addPinnedPlace(locationDetail)
        }
    }
    
    private func startRecord() {
        /* TODO: - background 에서 돌아가게 하려고 corelocation에서 위도 경도를 받아오고 있습니다. 논의가 필요해요 :)
        routeRecorder.startRecording()
        routeRecorder.locationPublisher
        */
        locationManager = LocationManager()
        
        generateTravel()
        locationManager?.locationPublisher
            .sink { [weak self] location in
                self?.savedRoute.routePoints.append(contentsOf: location)
                self?.outputSubject.send(.updateRoute(self?.savedRoute.routePoints ?? []))
            }
            .store(in: &cancellables)
        
        
    }
    
    private func generateTravel() {
        let currentTime: Date = Date()
        self.currentTravel = TravelInfo(id: UUID().uuidString, sequence: 0, startAt: currentTime)
    }
    
    private func completeTravel() {
        let transRoute = savedRoute.routePoints.map{[$0.coordinate.latitude, $0.coordinate.longitude]}
        let pinnedTransROUTE = savedRoute.pinnedPlaces.map{[Double($0.mapx), Double($0.mapy)]}
        self.currentTravel?.recordedLocation = transRoute
        self.currentTravel?.recordedPindedLocation = transRoute
        
    }
    
    private func stopRecord() {
        let currentTime: Date = Date()
        guard let travel = self.currentTravel,
              let recordedLocation = travel.recordedLocation,
              let recordedPindedLocation = travel.recordedPindedLocation,
              let startAt = travel.startAt,
              let endAt = travel.endAt
        else { return }
        
        CoreDataManager.shared.saveTravel(id: travel.id,
                                          recordedLocation: recordedLocation,
                                          recordedPindedLocation: recordedPindedLocation,
                                          sequence: Int(travel.sequence),
                                          startAt: startAt,
                                          endAt: endAt)
        routeRecorder.stopRecording()
       
        locationManager = nil
    }
    
    private func searchPlace(with text: String) {
        locationSearcher.searchLocation(query: text, page: searchPageNum)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] response in
                self?.searchedResult = response
                self?.outputSubject.send(.updateSearchResult(response))
                self?.searchPageNum = 1
            }.store(in: &cancellables)
    }
    
    func movePinnedPlace(from sourceIndex: Int, to destinationIndex: Int) {
        savedRoute.pinnedPlaces = pinnedPlaceManager.movePinnedPlace(from: sourceIndex, to: destinationIndex, in: savedRoute.pinnedPlaces)
        outputSubject.send(.updatePinnedPlacesTableView(savedRoute.pinnedPlaces))
        outputSubject.send(.updateMarkers(savedRoute.pinnedPlaces))
    }
    
    func addPinnedPlace(_ locationDetail: LocationDetail) {
        savedRoute.pinnedPlaces.append(locationDetail)
        outputSubject.send(.updatePinnedPlacesTableView(savedRoute.pinnedPlaces))
        outputSubject.send(.addPinnedPlaceInMap(locationDetail))
    }
    
    func removePinnedPlace(_ locationDetail: LocationDetail) {
        if let index = savedRoute.pinnedPlaces.firstIndex(where: { $0.placeName == locationDetail.placeName }) {
            savedRoute.pinnedPlaces.remove(at: index)
            outputSubject.send(.updatePinnedPlacesTableView(savedRoute.pinnedPlaces))
            outputSubject.send(.removePinnedPlaceInMap(locationDetail))
        }
    }
    
    func isPinned(_ locationDetail: LocationDetail) -> Bool {
        return savedRoute.pinnedPlaces.contains(where: { $0.placeName == locationDetail.placeName })
    }
    
}
