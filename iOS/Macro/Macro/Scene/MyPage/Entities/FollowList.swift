//
//  FollowList.swift
//  Macro
//
//  Created by 김나훈 on 12/5/23.
//

import Foundation

struct FollowList: Codable {
    let email: String
    let name: String
    let imageUrl: String?
    let introduce: String?
    let followersNum: Int
    let followeesNum: Int
}
