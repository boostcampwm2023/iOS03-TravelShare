//
//  RouteInfo.swift
//  Macro
//
//  Created by Byeon jinha on 11/17/23.
//

import Foundation

struct RouteInfo: Codable {
    let postid: Int
    let title: String
    let view, likes: Int
    let summary: String
    let image: String
    let route, hashtag: [String]
}
