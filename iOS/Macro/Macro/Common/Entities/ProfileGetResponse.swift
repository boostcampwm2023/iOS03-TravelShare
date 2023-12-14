//
//  ProfileGetResponse.swift
//  Macro
//
//  Created by Byeon jinha on 11/28/23.
//

import Foundation

struct ProfileGetResponse: Codable {
    let userId: String
    let name: String
    let imageUrl: String?
    let introduce: String?
    let following: Bool
    let follower: Bool
    let followersNum: Int
    let followingsNum: Int
    let posts: [PostFindResponse]
}
