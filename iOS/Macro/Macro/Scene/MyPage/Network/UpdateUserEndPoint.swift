//
//  UpdateUserEndPoint.swift
//  Macro
//
//  Created by 김나훈 on 11/29/23.
//

import Combine
import Foundation
import MacroNetwork

enum UpdateUserEndPoint {
    case cellIndex(Int, String)
    case uploadImage(Data)
}

extension UpdateUserEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case .cellIndex:
            let token = KeyChainManager.load(key: "AccessToken") ?? ""
            return ["Authorization": "Bearer \(token)"]
        case .uploadImage(let data):
            return [
                "Content-Type": "image/jpeg",
                "Content-Length": "\(data.count)",
                "Host": "jijihuny.store"
            ]
        }
        
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .cellIndex(index, query):
            switch index {
            case 0: return .query(["name": query])
            case 1: return .query(["imageUrl": query])
            default: return .query(["introduce": query])
            }
        case let .uploadImage(imageData):
            return .data(imageData)
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .cellIndex:
            return .patch
        case .uploadImage:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .cellIndex:
            return "user/update"
        case .uploadImage:
            return "file/put"
        }
    }
}
