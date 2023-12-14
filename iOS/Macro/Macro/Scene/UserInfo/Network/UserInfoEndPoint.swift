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
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .search(email):
            return .query(["email": email])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        return "user/profile"
    }
}
