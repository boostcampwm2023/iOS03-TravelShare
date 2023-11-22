//
//  TravelEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 11/16/23.
//

import Foundation
import MacroNetwork

enum TravelEndPoint {
    case search(String, Int)
}

extension TravelEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        return []
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .search(text, page):
            return .query(["keyword": text, "pagenum": String(page)])
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
