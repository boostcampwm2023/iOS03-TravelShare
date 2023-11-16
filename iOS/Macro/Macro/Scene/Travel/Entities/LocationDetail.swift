//
//  LocationDetail.swift
//  Macro
//
//  Created by 김나훈 on 11/15/23.
//

import Foundation

struct LocationDetail: Codable {
  let title: String
  let link: String
  let category: String
  let description: String?
  let telephone: String?
  let address: String
  let roadAddress: String
  let mapx: Double
  let mapy: Double
}
