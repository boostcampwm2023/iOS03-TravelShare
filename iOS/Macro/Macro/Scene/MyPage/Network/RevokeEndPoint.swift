//
//  RevokeEndPoint.swift
//  Macro
//
//  Created by Byeon jinha on 12/6/23.
//

import Foundation
import MacroNetwork

enum RevokeEndPoint {
    case withdraw(identityToken: String, authorizationCode: String, acccessToken: String)
}

extension RevokeEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case let .withdraw(identityToken, authorizationCode, acccessToken):
            return [
                "Authorization": "Bearer \(acccessToken)",
                "Host": "jijihuny.store",
                "Content-Type": "application/json",
                "Content-Length": "\(identityToken.count + authorizationCode.count + acccessToken.count)"
            ]
        }
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .withdraw(identityToken, authorizationCode, _):
            return .body(["identityToken": identityToken,
                          "authorizationCode": authorizationCode])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .withdraw:
            return .delete
        }
    }
    
    var path: String {
        return "apple/revoke"
    }
}
