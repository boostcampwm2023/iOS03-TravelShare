//
//  PatchUseCase.swift
//  Macro
//
//  Created by 김나훈 on 11/29/23.
//

import Combine
import Foundation
import MacroNetwork

protocol PatchUseCase {
    
    func patchUser(cellIndex: Int, query: String) -> AnyPublisher<PatchResponse, NetworkError>
    func patchPostLike(postId: Int) -> AnyPublisher<LikePostResponse, NetworkError>
}

final class Patcher: PatchUseCase {
    
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    
    init(provider: Requestable) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func patchUser(cellIndex: Int, query: String) -> AnyPublisher<PatchResponse, MacroNetwork.NetworkError> {
        return provider.request(UpdateUserEndPoint.cellIndex(cellIndex, query))
    }
    
    func patchPostLike(postId: Int) -> AnyPublisher<LikePostResponse, MacroNetwork.NetworkError> {
        return provider.request(UpdateLikeEndPoint.postLike(postId))
    }
}
