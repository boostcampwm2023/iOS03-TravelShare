//
//  FollowEndPoint.swift
//  Macro
//
//  Created by Byeon jinha on 11/27/23.
//

import Foundation
import MacroNetwork

enum FollowEndPoint {
    case follow(String)
}

extension FollowEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        return []
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .follow(userId):
            return .query(["userId": userId])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .follow:
            return .get
        }
    }
    
    var path: String {
        return "map/v2/searchByAccuracy"
    }
}
