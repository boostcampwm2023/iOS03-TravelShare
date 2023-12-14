//
//  UpdateFollowEndPoint.swift
//  Macro
//
//  Created by Byeon jinha on 12/2/23.
//

import Combine
import Foundation
import MacroNetwork

enum UpdateFollowEndPoint {
    case userFollow(String)
}

extension UpdateFollowEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .userFollow(email):
            return .query(["followee": email])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .userFollow:
            return .patch
        }
    }
    
    var path: String {
        return "user/folloew"
    }
}
