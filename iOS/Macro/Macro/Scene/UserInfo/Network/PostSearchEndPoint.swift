//
//  PostSearchEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 11/29/23.
//

import Foundation
import MacroNetwork

enum PostSearchEndPoint {
    case search(String, Int)
}

extension PostSearchEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .search(email, skip):
            return .query(["email": email, "skip": "\(skip)"])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        return "post/search"
    }
}
