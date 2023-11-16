//
//  TravelEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 11/16/23.
//

import Foundation
import Network

enum TravelEndPoint {
  case search(String)
}

extension TravelEndPoint: EndPoint {
  
  var baseURL: String {
    return "http://118.67.130.85:3000"
  }
  
  var headers: Network.HTTPHeaders {
    return []
  }
  
  var parameter: Network.HTTPParameter {
    switch self {
    case let .search(text):
      return .query(["keyword": text])
    }
  }
  
  var method: Network.HTTPMethod {
    switch self {
    case .search:
      return .get
    }
  }
  
  var path: String {
    return "map/search"
  }
}
