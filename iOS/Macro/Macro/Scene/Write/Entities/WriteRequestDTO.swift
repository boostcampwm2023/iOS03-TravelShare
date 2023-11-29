//
//  WriteRequestDTO.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Foundation

// MARK: - Welcome
struct Post: Codable {
    let title, summary: String
    let route: Route
    let contents: [Content]
    let postPublic: Bool
    let startAt, endAt: String

    enum CodingKeys: String, CodingKey {
        case title, summary, route, contents
        case postPublic = "public"
        case startAt, endAt
    }
}
