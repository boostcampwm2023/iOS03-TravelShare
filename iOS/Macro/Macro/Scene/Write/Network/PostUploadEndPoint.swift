//
//  PostUploadEndPoint.swift
//  Macro
//
//  Created by 김경호 on 11/29/23.
//

import Foundation
import MacroNetwork

enum PostUploadEndPoint {
    case uploadPost(post: Post, token: String)
}

extension PostUploadEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case let .uploadPost(post, token):
            return [
                "Host": "jijihuny.store",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .uploadPost(post, _):
            return .body(post)
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .uploadPost:
            return .post
        }
    }
    
    var path: String {
        return "post/upload"
    }
}
