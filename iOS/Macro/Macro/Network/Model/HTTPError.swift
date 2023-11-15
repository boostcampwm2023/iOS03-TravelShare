//
//  HTTPError.swift
//  Macro
//
//  Created by 김경호 on 11/16/23.
//

import Foundation

public enum HTTPError: LocalizedError {
    case unknownError
    case idAreadyExist
    case parameterError
    case emptyBody
    case invalidURL
    case decodingError
    case invalidResponse
    
    public var errorDescription: String? {
        switch self {
        case .unknownError: return "알 수 없는 에러입니다."
        case .idAreadyExist: return "이미 사용중인 아이디입니다."
        case .parameterError: return "Parameter가 잘못되었습니다."
        case .emptyBody: return "body가 비어있습니다."
        case .invalidURL: return "잘못된 URL입니다."
        case .decodingError: return "decode 에러가 발생했습니다."
        case .invalidResponse: return "잘못된 응답입니다."
        }
    }
}
