//
//  ReadPost.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Foundation

struct ReadPost: Codable {
    let postId: Int
    let title: String
    let viewNum, likeNum: Int
    let createdAt, modifiedAt: String
    let contents: [Content]
    let writer: Writer
    let route: Route
    let pins: [Pin]
    let liked: Bool
}
