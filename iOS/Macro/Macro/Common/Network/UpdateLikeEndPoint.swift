//
//  UpdateLikeEndPoint.swift
//  Macro
//
//  Created by Byeon jinha on 12/1/23.
//

import Combine
import Foundation
import MacroNetwork

enum UpdateLikeEndPoint {
    case postLike(Int)
}

extension UpdateLikeEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .postLike(postId):
            return .query(["postId": postId])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .postLike:
            return .patch
        }
    }
    
    var path: String {
        return "post/like"
    }
}
