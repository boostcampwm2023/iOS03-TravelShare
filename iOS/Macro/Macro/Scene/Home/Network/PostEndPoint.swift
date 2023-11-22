//
//  PostEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import Foundation
import MacroNetwork

enum PostEndPoint {
    case search
}

extension PostEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://118.67.130.85:3000"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        return []
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case .search:
            return .plain
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        return "map/search"
    }
}
