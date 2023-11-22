//
//  LocationDetail.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Foundation

struct LocationDetail: Codable, Hashable {
  let addressName: String
  let categoryGroupCode: String
  let categoryGroupName: String
  let categoryName: String
  let distance: String
  let id: String
  let phone: String?
  let placeName: String
  let placeUrl: String
  let roadAddressName: String
  let mapx: String
  let mapy: String

  enum CodingKeys: String, CodingKey {
    case addressName = "address_name"
    case categoryGroupCode = "category_group_code"
    case categoryGroupName = "category_group_name"
    case categoryName = "category_name"
    case distance
    case id
    case phone
    case placeName = "place_name"
    case placeUrl = "place_url"
    case roadAddressName = "road_address_name"
    case mapx = "x"
    case mapy = "y"
  }
}
