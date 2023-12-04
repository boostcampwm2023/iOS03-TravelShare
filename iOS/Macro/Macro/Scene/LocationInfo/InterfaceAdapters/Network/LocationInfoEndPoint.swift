//
//  LocationInfoNetwork.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import Combine
import Foundation
import MacroNetwork

enum LocationInfoEndPoint {
    case relatedPost(String)
    case relatedLocation(String)
    
}

extension LocationInfoEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case .relatedPost(let postId):
            return .query(["placeId": postId])
        case .relatedLocation(let postId):
            return .query(["placeId": postId])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .relatedPost:
            return "post/search"
        case .relatedLocation:
            return "post/find"
        }
    }
}
