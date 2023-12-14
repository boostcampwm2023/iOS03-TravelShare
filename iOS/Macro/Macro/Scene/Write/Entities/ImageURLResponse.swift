//
//  ImageURLResponse.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Foundation

struct ImageURLResponse: Codable {
    let url: String
    let etag: String?
}
