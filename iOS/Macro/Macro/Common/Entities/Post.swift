//
//  Post.swift
//  Macro
//
//  Created by 김경호 on 11/29/23.
//

import Foundation

struct Post: Codable {
    let title, summary: String
    let route: Route
    let pins: [Pin]
    let contents: [Content]
    let postPublic: Bool
    let startAt, endAt: String

    enum CodingKeys: String, CodingKey {
        case title, summary, route, contents, pins, startAt, endAt
        case postPublic = "public"
    }
}

struct Route: Codable {
    let coordinates: [Coordinate]
}

struct Pin: Codable {
    let placeId: String
    let placeName: String
    let phoneNumber: String
    let category: String
    let address: String
    let roadAddress: String
    let coordinate: Coordinate
}
