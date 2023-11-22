//
//  PostFindEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import Foundation
import MacroNetwork

enum PostFindEndPoint {
    case search(String)
}

extension PostFindEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        return []
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .search(text):
            return .query(["post": text])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        return ""
    }
}
