//
//  RouteManager.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Foundation
import MacroNetwork

/// 사용자가 핀으로 고정한 장소를 관리하는 UseCase
protocol PinnedPlaceManageUseCase {
  
  /// 핀으로 특정 장소를 추가하는 함수
  func addPinnedLocation(locationDetail: LocationDetail, to places: [LocationDetail]) -> [LocationDetail]
  
  func deletePinnedLocation(locationDetail: LocationDetail, to places: [LocationDetail]) -> [LocationDetail]
  
  func movePinnedPlace(from sourceIndex: Int, to destinationIndex: Int, in places: [LocationDetail]) -> [LocationDetail]
 }

final class PinnedPlaceManager: PinnedPlaceManageUseCase {
  
  // MARK: Properties
  
  private let provider: Requestable
  
  // MARK: Init
  
  init(provider: Requestable) {
    self.provider = provider
  }
  
  // MARK: Methods
  
  func addPinnedLocation(locationDetail: LocationDetail, to places: [LocationDetail]) -> [LocationDetail] {
    var newPlaces = places
    newPlaces.append(locationDetail)
    return newPlaces
  }
  
  func deletePinnedLocation(locationDetail: LocationDetail, to places: [LocationDetail]) -> [LocationDetail] {
    var newPlaces = places
    if let index = newPlaces.firstIndex(where: { $0.placeName == locationDetail.placeName }) {
      newPlaces.remove(at: index)
    }
    return newPlaces
  }
  
  func movePinnedPlace(from sourceIndex: Int, to destinationIndex: Int, in places: [LocationDetail]) -> [LocationDetail] {
    var updatedPlaces = places
           let movedItem = updatedPlaces.remove(at: sourceIndex)
           updatedPlaces.insert(movedItem, at: destinationIndex)
           return updatedPlaces
  }
}
