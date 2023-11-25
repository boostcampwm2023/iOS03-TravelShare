//
//  ReadEndPoint.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Foundation
import MacroNetwork

enum ReadEndPoint {
    case read(postId: String, accessToken: String)
}

extension ReadEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case .read(_, _):
            return [
                "Host" : "jijihuny.store"
            ]
        }
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .read(postId, accessToken):
            return .body([
                "postId": postId,
                "accessToken": accessToken
            ])
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
