//
//  ReadEndPoint.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Foundation
import MacroNetwork

enum ReadEndPoint {
    case read(postId: Int, accessToken: String)
}

extension ReadEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case let .read(_, accessToken):
            return [
                "Host" : "jijihuny.store",
                "Authorization" : "Bearer " + accessToken
            ]
        }
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .read(postId, _):
            return .query(["postId" : postId])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .read(_, _):
            return .get
        }
    }
    
    var path: String {
        return "post/detail"
    }
}
