//
//  ConfirmError.swift
//  Macro
//
//  Created by 김나훈 on 11/30/23.
//

import Foundation

enum ConfirmError: String, Error {
    case invalidNickNameLength
    case invalidNickNameCharacter
    case multipleSpacing
    case invalidIntroduceLength
    case invalidLineBreak
}

extension ConfirmError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidNickNameLength:
            return "3글자에서 11글자 사이로 입력하세요."
        case .invalidNickNameCharacter:
            return "한글, 영어, 띄어쓰기만 입력 가능합니다."
        case .multipleSpacing:
            return "띄어쓰기는 연속으로 2개 이상 사용할 수 없습니다."
        case .invalidIntroduceLength:
            return "60자 이내로 입력해주세요."
        case .invalidLineBreak:
            return "줄바꿈을 3회 이상 할 수 없습니다."
        }
    }
}
