//
//  RefreshTokenEndPoint.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Foundation
import MacroNetwork

enum RefreshTokenEndPoint {
    case refreshToken(String)
}

extension RefreshTokenEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case let .refreshToken(accessToken):
            return [
                "Authorization" : "Bearer " + accessToken,
                "Host" : "jijihuny.store"
            ]
        }
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case .refreshToken:
            return .plain
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .refreshToken:
            return .put
        }
    }
    
    var path: String {
        return "auth/refresh"
    }
}
