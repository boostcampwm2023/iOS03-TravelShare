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
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .follow(email):
            return .query(["followee": email])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .follow:
            return .patch
        }
    }
    
    var path: String {
        return "user/follow"
    }
}
