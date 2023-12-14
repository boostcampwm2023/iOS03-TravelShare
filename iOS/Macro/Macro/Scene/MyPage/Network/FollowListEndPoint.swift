//
//  FollowListEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 12/5/23.
//

import Foundation
import MacroNetwork

enum FollowListEndPoint {
    case followType(FollowType, String)
}

extension FollowListEndPoint: EndPoint {
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
        return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .followType(_, email):
            return .query(["email": email])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .followType(let followType, _):
            switch followType {
            case .followers:
                return "user/followers"
            case .followees:
                return "user/followees"
            }
        }
    }
}
