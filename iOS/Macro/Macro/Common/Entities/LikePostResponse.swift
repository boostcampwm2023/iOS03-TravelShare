//
//  LikePostResponse.swift
//  Macro
//
//  Created by Byeon jinha on 12/1/23.
//

import Foundation

struct LikePostResponse: Codable {
    var likeNum: Int
    let postId: Int
    let liked: Bool
}
