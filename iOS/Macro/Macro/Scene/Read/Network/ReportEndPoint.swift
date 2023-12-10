//
//  ReportEndPoint.swift
//  Macro
//
//  Created by Byeon jinha on 12/10/23.
//

import Foundation
import MacroNetwork

enum ReportEndPoint {
    case report(postId: String, title: String, description: String)
}

extension ReportEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case .report:
            let accessToken = KeyChainManager.load(key: KeyChainManager.Keywords.accessToken) ?? ""
            return [
                "Host": "jijihuny.store",
                "Authorization": "Bearer " + accessToken
            ]
        }
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .report(postId, title, description):
            return .query(["postId": postId, "title": title, "description": description])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .report:
            return .post
        }
    }
    
    var path: String {
        return "report/post"
    }
}
