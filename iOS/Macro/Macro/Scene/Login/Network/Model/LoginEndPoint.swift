//
//  LoginEndPoint.swift
//  Macro
//
//  Created by 김경호 on 11/20/23.
//

import Foundation
import MacroNetwork

enum LoginEndPoint {
    case login(identityToken: String)
}

extension LoginEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case let .login(identityToken):
            return [
                "Content-Type" : "application/json",
                "Contents-Length" : "\(identityToken.count)",
                "Host" : "jijihuny.store"
            ]
        }
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .login(identityToken):
            return .body(["identityToken": identityToken])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var path: String {
        return "apple/auth"
    }
}
