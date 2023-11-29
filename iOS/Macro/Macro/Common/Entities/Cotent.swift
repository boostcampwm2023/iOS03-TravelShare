//
//  Cotent.swift
//  Macro
//
//  Created by 김경호 on 11/29/23.
//

import Foundation

struct Content: Codable {
    var imageURL: String?
    var description: String?
    var coordinate: Coordinate?

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case description, coordinate
    }
}
