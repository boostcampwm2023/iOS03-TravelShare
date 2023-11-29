//
//  PatchResponse.swift
//  Macro
//
//  Created by 김나훈 on 11/29/23.
//

import Foundation

struct PatchResponse: Codable {
    let message: String
    let error: String?
    let statusCode: Int
}
