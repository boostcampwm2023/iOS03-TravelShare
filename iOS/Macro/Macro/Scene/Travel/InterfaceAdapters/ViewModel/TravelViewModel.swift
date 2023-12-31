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
    
    // MARK: - Properties
    
    private var currentTravel: TravelInfo?
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let locationSearcher: SearchUseCase
    private let pinnedPlaceManager: PinnedPlaceManageUseCase
    private var cancellables = Set<AnyCancellable>()
    private var locationSubscription: AnyCancellable?
    private (set) var savedRoute: SavedRoute = SavedRoute()
    private (set) var searchedResult: [LocationDetail] = [] {
        didSet {
            outputSubject.send(.transViewBySearchedResultCount(searchedResult.isEmpty))
        }
    }
    private var searchPageNum = 1
    
    // MARK: - Input
    
    enum Input {
        case startTravel
        case endTravel
        case searchLocation(String)
        case togglePinnedPlaces(LocationDetail)
        case selectLocation(LocationDetail)
        case selectSearchedcell(Double, Double)
    }
    
    // MARK: - Output
    
    enum Output {
        case exchangeCell
        case exchangeLocation
        case updateSearchResult([LocationDetail])
        case updatePinnedPlacesTableView
        case addPinnedPlaceInMap(LocationDetail)
        case removePinnedPlaceInMap(LocationDetail)
        case updateRoute(CLLocation)
        case updateMarkers
        case showLocationInfo(LocationDetail)
        case moveCamera(Double, Double)
        case removeMapLocation
        case transViewBySearchedResultCount(Bool)
        case breakRecord
    }
    
    // MARK: - Init
    
    init(locationSearcher: SearchUseCase, pinnedPlaceManager: PinnedPlaceManageUseCase) {
        self.locationSearcher = locationSearcher
        self.pinnedPlaceManager = pinnedPlaceManager
    }
}

// MARK: - Methods

extension TravelViewModel {
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .startTravel:
                self?.startRecord()
            case .endTravel:
                self?.stopRecord()
            case let .searchLocation(text):
                self?.searchPlace(with: text)
            case let .togglePinnedPlaces(locationDetail):
                self?.togglePinnedPlaces(locationDetail)
            case let .selectLocation(locationDetail):
                self?.outputSubject.send(.showLocationInfo(locationDetail))
            case let .selectSearchedcell(mapX, mapY):
                self?.outputSubject.send(.moveCamera(mapX, mapY))
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    func togglePinnedPlaces(_ locationDetail: LocationDetail) {
        if savedRoute.pinnedPlaces.contains(where: { $0.id == locationDetail.id}) {
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
        locationSubscription?.cancel() // 이전 구독 취소
           generateTravel()
           LocationManager.shared.startRecording()
           locationSubscription = LocationManager.shared.locationPublisher
               .sink { [weak self] location in
                guard let self = self else { return }
                guard let location = location else { return }
                
                if self.savedRoute.routePoints.isEmpty {
                    self.savedRoute.routePoints.append(contentsOf: [location, location])
                    self.outputSubject.send(.updateRoute(location))
                }
                else if self.savedRoute.routePoints.last == location { }
                else if self.savedRoute.routePoints.count >= 10000 {
                    self.outputSubject.send(.breakRecord)
                }
                else {
                    self.savedRoute.routePoints.append(location)
                    self.outputSubject.send(.updateRoute(location))
                }
            }
            
    }
    
    private func generateTravel() {
        let currentTime: Date = Date()
        do {
            let sequence = try CoreDataManager.shared.calculateNextSequence()
            self.currentTravel = TravelInfo(id: UUID().uuidString, sequence: sequence, startAt: currentTime)
        } catch {
            
        }
    }
    
    private func stopRecord() {
        completeTravel()
        guard let travel = self.currentTravel,
              let recordedLocation = travel.recordedLocation,
              let startAt = travel.startAt,
              let endAt = travel.endAt
        else { return }
        
        CoreDataManager.shared.saveTravel(id: travel.id,
                                          recordedLocation: recordedLocation,
                                          recordedPinnedLocations: travel.recordedPinnedLocations,
                                          sequence: Int(travel.sequence),
                                          startAt: startAt,
                                          endAt: endAt)
    
        LocationManager.shared.stopRecording()
        savedRoute = SavedRoute()
        locationSubscription?.cancel() 
            locationSubscription = nil
        outputSubject.send(.removeMapLocation)
        outputSubject.send(.updatePinnedPlacesTableView)
    }
    
    private func completeTravel() {
        let transRoute = savedRoute.routePoints.map({ [$0.coordinate.latitude, $0.coordinate.longitude] })
        let pinnedTransRoute: [RecordedPinnedLocationInfomation] = savedRoute.pinnedPlaces.map { RecordedPinnedLocationInfomation(
            placeId: $0.id,
            placeName: $0.placeName,
            phoneNumber: $0.phone,
            category: $0.categoryName,
            address: $0.addressName,
            roadAddress: $0.roadAddressName,
            coordinate: PinnedLocation(latitude: Double($0.mapy) ?? 0,
                                       longitude: Double($0.mapx) ?? 0))
        }
        self.currentTravel?.recordedLocation = transRoute
        self.currentTravel?.recordedPinnedLocations = pinnedTransRoute
        let currentTime: Date = Date()
        self.currentTravel?.endAt = currentTime
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
        outputSubject.send(.updatePinnedPlacesTableView)
        outputSubject.send(.updateMarkers)
    }
    
    func addPinnedPlace(_ locationDetail: LocationDetail) {
        savedRoute.pinnedPlaces.append(locationDetail)
        outputSubject.send(.updatePinnedPlacesTableView)
        outputSubject.send(.addPinnedPlaceInMap(locationDetail))
    }
    
    func removePinnedPlace(_ locationDetail: LocationDetail) {
        if let index = savedRoute.pinnedPlaces.firstIndex(where: { $0.id == locationDetail.id }) {
            savedRoute.pinnedPlaces.remove(at: index)
            outputSubject.send(.updatePinnedPlacesTableView)
            outputSubject.send(.removePinnedPlaceInMap(locationDetail))
        }
    }
    
    func isPinned(_ locationDetail: LocationDetail) -> Bool {
        return savedRoute.pinnedPlaces.contains(where: { $0.id == locationDetail.id })
    }
    
}
