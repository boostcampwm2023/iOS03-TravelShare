//
//  UserSearcher.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation
import MacroNetwork

protocol UserSearchUseCase {
}

final class UserSearcher: UserSearchUseCase {
    
    private let provider: Requestable
    
    init(provider: Requestable) {
        self.provider = provider
    }
}
