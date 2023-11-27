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
    func followUser(userId: String) -> AnyPublisher<FollowResponse, NetworkError>
    func mockFollowUser(userId: String, followUserId: String, json: String) -> AnyPublisher<FollowResponse, NetworkError>
}

final class FollowFeature: FollowUseCase {
    
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    init(provider: Requestable) {
        self.provider = provider
    }
    
    func followUser(userId: String) -> AnyPublisher<FollowResponse, MacroNetwork.NetworkError> {
        return provider.request(FollowEndPoint.follow(userId))
    }
    
    func mockFollowUser(userId: String, followUserId: String, json: String) -> AnyPublisher<FollowResponse, MacroNetwork.NetworkError> {
        return provider.mockRequest(FollowEndPoint.follow(userId), url: json)
    }
}
