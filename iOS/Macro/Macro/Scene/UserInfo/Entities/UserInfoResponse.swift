//
//  UserInfoResponse.swift
//  Macro
//
//  Created by Byeon jinha on 11/23/23.
//

import Foundation

struct UserInfoResponse: Codable {
    let name: String
    var follower: Int
    let introduce: String
    let userImageURL: String
    let isFollow: Bool
}
