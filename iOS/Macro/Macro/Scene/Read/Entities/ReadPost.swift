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
    let hashtag: [String]
    let createdAt, modifiedAt: String
    let contents: [Content]
    let writer: Writer
    let route: Route
    let liked: Bool
}

// MARK: - Content
struct Content: Codable {
    let imageURL: String
    let description: String?
    let coordinate: Coordinate?

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case description, coordinate
    }
}

// MARK: - Coordinate
struct Coordinate: Codable {
    let xPosition: Double
    let yPosition: Double
    
    enum CodingKeys: String, CodingKey {
        case xPosition = "x"
        case yPosition = "y"
    }
}

// MARK: - Route
struct Route: Codable {
    let coordinates: [Coordinate]?
}
