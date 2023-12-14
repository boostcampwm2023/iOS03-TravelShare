//
//  FollowPatchResponse.swift
//  Macro
//
//  Created by Byeon jinha on 12/2/23.
//

import Foundation

struct FollowPatchResponse: Codable {
    let followee: FollowPatchFollowee
    let follower: FollowPatchFollower
}
