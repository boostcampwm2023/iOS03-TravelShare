//
//  LoginResponse.swift
//  Macro
//
//  Created by 김경호 on 11/16/23.
//

import Foundation

struct LoginResponse: Decodable {
    let refreshToken: String
    let accessToken: String
}