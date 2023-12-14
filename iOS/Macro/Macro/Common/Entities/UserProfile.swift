//
//  UserProfile.swift
//  Macro
//
//  Created by 김나훈 on 11/29/23.
//

import Foundation

struct UserProfile: Codable {
    let email: String
    var name: String
    var imageUrl: String?
    var introduce: String?
    let followersNum: Int
    let followeesNum: Int
    let followee: Bool
    let follower: Bool
}
