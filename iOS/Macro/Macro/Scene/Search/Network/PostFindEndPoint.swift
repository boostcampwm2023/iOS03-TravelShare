//
//  PostFindEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import Foundation
import MacroNetwork

enum PostFindEndPoint {
    case searchPost(String)
    case searchAccount(String)
}

extension PostFindEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .searchPost(text):
            return .query(["title": text])
        case let .searchAccount(text):
            return .query(["name": text])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .searchPost:
            return "post/search"
        case .searchAccount:
            return "user/search"
        }
    }
}
