//
//  ReadPost.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Foundation

struct ReadPost: Codable {
    let postId: Int
    let title: String?
    let contents: [PostContent]?
    let writer: Writer?
    let route: [String]?
    let hashtag: [String]?
    let likeNum: Int?
    let viewNum: Int?
    let createdAt: Date?
    let modifiedAt: Date?
    let liked: Bool?
}

struct PostContent: Codable {
    let imageUrl: String?
    let description: String?
//    let x: Int?
//    let y: Int?
}

struct Writer: Codable {
    let email: String?
    let name: String?
    let imageUrl: String?
}
