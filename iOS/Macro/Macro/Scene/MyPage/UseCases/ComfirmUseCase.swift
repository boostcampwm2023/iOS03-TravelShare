//
//  ComfirmUseCase.swift
//  Macro
//
//  Created by 김나훈 on 11/30/23.
//

import Foundation

protocol ConfirmUseCase {
    func confirmNickName(text: String) -> Result<Void, ConfirmError>
    func confirmIntroduce(text: String) -> Result<Void, ConfirmError>
}

struct Confirmer: ConfirmUseCase {
    func confirmNickName(text: String) -> Result<Void, ConfirmError> {
        if isValidNickNameLength(text: text) { return .failure(.invalidNickNameLength) }
        else if isValidNickNameCharacter(text: text) { return .failure(.invalidNickNameCharacter) }
        else if isValidSpacing(text: text) { return .failure(.multipleSpacing)}
        
        return .success(())
    }
    
    func confirmIntroduce(text: String) -> Result<Void, ConfirmError> {
        if isValidIntroduceLength(text: text) { return .failure(.invalidIntroduceLength) }
        else if isValidLineBreak(text: text) { return .failure(.invalidLineBreak) }
        
        return .success(())
    }
}

// MARK: - Check NickName

extension Confirmer {
    private func isValidNickNameLength(text: String) -> Bool {
        return (3...11).contains(text.count)
    }
    
    private func isValidNickNameCharacter(text: String) -> Bool {
        return text.range(of: "^[가-힣A-Za-z\\s]+$", options: .regularExpression) != nil
    }
    
    private func isValidSpacing(text: String) -> Bool {
        return !text.contains("  ")
    }
}

// MARK: - Check Introduce

extension Confirmer {
    private func isValidIntroduceLength(text: String) -> Bool {
        return text.count <= 60
    }
    
    private func isValidLineBreak(text: String) -> Bool {
        return text.filter { $0.isNewline }.count <= 2
    }
}
