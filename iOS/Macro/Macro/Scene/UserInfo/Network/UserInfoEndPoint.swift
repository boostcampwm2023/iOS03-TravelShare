//
//  UserInfoEndPoint.swift
//  Macro
//
//  Created by Byeon jinha on 11/27/23.
//

import Foundation
import MacroNetwork

enum UserInfoEndPoint {
    case search(String)
}

extension UserInfoEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        return []
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .search(userId):
            return .query(["userId": userId])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        return "map/v2/searchByAccuracy"
    }
}
