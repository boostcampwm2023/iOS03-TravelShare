//
//  RouteManager.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Foundation
import Network

/// 사용자가 핀으로 고정한 장소를 관리하는 UseCase
protocol PinnedPlaceManageUseCase {
  
  /// 핀으로 지정한 장소를 지우는 함수
  func deleteRoute()
  
  /// 핀으로 지정한 장소의 순서를 바꾸는 함수
  func exchangeRoute()
  
  /// 핀으로 특정 장소를 추가하는 함수
  func addPinnedLocation(locationDetail: LocationDetail)
  
  /// 현재 핀으로 추가된 장소들의 정보를 얻는 함수
  func getCurrendPinnedPlaces() -> [LocationDetail]
}

final class PinnedPlaceManager: PinnedPlaceManageUseCase {
  
  private let provider: Requestable
  private var pinnedPlace: [LocationDetail] = []
  
  init(provider: Requestable) {
    self.provider = provider
  }
  
  func deleteRoute() {
    // TODO: complete method
  }
  
  func exchangeRoute() {
    // TODO: complete method
  }
  
  func getCurrendPinnedPlaces() -> [LocationDetail] {
    return pinnedPlace
  }
  
  func addPinnedLocation(locationDetail: LocationDetail) {
    pinnedPlace.append(locationDetail)
    print(pinnedPlace.count)
  }
}
