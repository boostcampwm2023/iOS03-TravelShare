//
//  UserProfile.swift
//  Macro
//
//  Created by 김나훈 on 11/29/23.
//

import Foundation

struct UserProfile: Codable {
    let email: String
    let name: String
    let imageUrl: String?
    let introduce: String?
    let followersNum: Int
    let followeesNum: Int
}
