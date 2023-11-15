//
//  LoginRequestDTO.swift
//  Macro
//
//  Created by 김경호 on 11/16/23.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let identityToken: String
    let authorizationCode: String
}
