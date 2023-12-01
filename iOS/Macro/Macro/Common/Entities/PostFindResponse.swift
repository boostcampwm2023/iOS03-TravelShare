//
//  PostResponse.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import Foundation

struct PostFindResponse: Codable {
    let postId: Int
    let title: String
    let summary: String
    let imageUrl: String?
    var likeNum: Int
    let viewNum: Int
    let writer: Writer
    var liked: Bool
}
