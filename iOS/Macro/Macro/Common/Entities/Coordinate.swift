//
//  Coordinate.swift
//  Macro
//
//  Created by 김경호 on 11/29/23.
//

import Foundation

struct Coordinate: Codable {
    let xPosition: Double
    let yPosition: Double
    
    enum CodingKeys: String, CodingKey {
        case xPosition = "x"
        case yPosition = "y"
    }
}
