//
//  PostEndPoint.swift
//  Macro
//
//  Created by Byeon jinha on 11/17/23.
//

import Foundation
import Network

enum PostEndPoint {
    case search
}

extension PostEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://118.67.130.85:3000"
    }
    
    var headers: Network.HTTPHeaders {
        return []
    }
    
    var parameter: Network.HTTPParameter {
        switch self {
        case .search:
            return .query("")
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
