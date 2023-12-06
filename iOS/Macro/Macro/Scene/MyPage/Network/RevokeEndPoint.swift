//
//  RevokeEndPoint.swift
//  Macro
//
//  Created by Byeon jinha on 12/6/23.
//

import Foundation
import MacroNetwork

enum RevokeEndPoint {
    case withdraw(identityToken: String, authorizationCode: String)
}

extension RevokeEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .withdraw(identityToken, authorizationCode):
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
