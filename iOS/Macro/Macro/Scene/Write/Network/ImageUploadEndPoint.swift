//
//  ImageUploadEndPoint.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Foundation
import MacroNetwork

enum ImageUploadEndPoint {
    case uploadImage(imageData: Data)
}

extension ImageUploadEndPoint: EndPoint {
    
    var baseURL: String {
        return "https://jijihuny.store"
    }
    
    var headers: MacroNetwork.HTTPHeaders {
        switch self {
        case let .uploadImage(imageData):
            return [
                "Content-Type" : "image/jpeg",
                "Contents-Length" : "\(imageData.count)",
                "Host" : "jijihuny.store"
            ]
        }
    }
    
    var parameter: MacroNetwork.HTTPParameter {
        switch self {
        case let .uploadImage(imageData):
            return .body([imageData])
        }
    }
    
    var method: MacroNetwork.HTTPMethod {
        switch self {
        case .uploadImage:
            return .put
        }
    }
    
    var path: String {
        return "file/put"
    }
}
