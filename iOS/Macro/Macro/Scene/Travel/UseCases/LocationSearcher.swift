//
//  LocationSearcher.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Combine
import Foundation
import Network

protocol LocationSearchUseCase {
  func searchLocation(query: String) -> AnyPublisher<[LocationDetail], NetworkError>
}

final class LocationSearcher: LocationSearchUseCase {

  // MARK: - Properties
  
  private let provider: Requestable

  // MARK: - Init
  
  init(provider: Requestable) {
    self.provider = provider
  }
  
  // MARK: - Methods
  
  func searchLocation(query: String) -> AnyPublisher<[LocationDetail], Network.NetworkError> {
    return provider.request(TravelEndPoint.search(query))
  }
      
}
