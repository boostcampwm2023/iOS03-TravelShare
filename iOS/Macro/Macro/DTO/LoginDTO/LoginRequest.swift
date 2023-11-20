//
//  LoginRequest.swift
//  Macro
//
//  Created by 김경호 on 11/16/23.
//

import Foundation

struct LoginRequest: Encodable {
    let identityToken: String
    let authorizationCode: String
}
