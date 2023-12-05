//
//  RelatedLocation.swift
//  Macro
//
//  Created by 김나훈 on 12/4/23.
//

import Foundation

struct RelatedLocation: Codable {
    let placeId: String
    let placeName: String
    let phoneNumber: String
    let category: String
    let address: String
    let roadAddress: String
    let coordinate: Coordinate
    let postNum: Int
}


