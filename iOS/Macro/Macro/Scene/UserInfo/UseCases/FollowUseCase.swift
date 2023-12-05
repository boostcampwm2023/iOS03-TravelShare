//
//  FollowUseCase.swift
//  Macro
//
//  Created by Byeon jinha on 11/27/23.
//

import Combine
import Foundation
import MacroNetwork

protocol FollowUseCase {
    func followUser(email: String) -> AnyPublisher<FollowResponse, NetworkError>
}

final class FollowFeature: FollowUseCase {
    
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    init(provider: Requestable) {
        self.provider = provider
    }
    
    func followUser(email: String) -> AnyPublisher<FollowResponse, MacroNetwork.NetworkError> {
        return provider.request(FollowEndPoint.follow(email))
    }
}
