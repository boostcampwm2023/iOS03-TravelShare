//
//  UserAgreementModel.swift
//  Macro
//
//  Created by Byeon jinha on 12/13/23.
//

import Foundation

struct UserAgreementModel {
    let type: UserAgreement
    let content: String
    var isCheck: Bool
    let url: URL?
}

enum UserAgreement {
    case total
    case service
    case personal
}
