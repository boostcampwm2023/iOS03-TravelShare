//
//  UpdateUserEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 11/29/23.
//

import Combine
import Foundation
import MacroNetwork

enum UpdateUserEndPoint {
    case cellIndex(Int, String)
}

extension UpdateUserEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .cellIndex(index, query):
            switch index {
            case 0: return .query(["name": query])
            case 1: return .query(["imageUrl": query])
            default: return .query(["introduce": query])
            }
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .cellIndex:
            return .patch
        }
    }
    
    var path: String {
        return "user/update"
    }
}
