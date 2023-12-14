//
//  FollowResponse.swift
//  Macro
//
//  Created by Byeon jinha on 11/27/23.
//

import Foundation

struct FollowResponse: Decodable {
    let followee: Followee
    let follower: Follower
}

struct Followee: Decodable {
    let email: String
    let followersNum: Int
    let followeesNum: Int
}

struct Follower: Decodable {
    let email: String
    let followersNum: Int
    let followeesNum: Int
}
