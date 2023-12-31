//
//  ReadPostUseCase.swift
//  Macro
//
//  Created by 김경호 on 11/26/23.
//

import Combine
import Foundation
import MacroNetwork

protocol ReadPostUseCaseProtocol {
    func execute(postId: Int) -> AnyPublisher<ReadPost, MacroNetwork.NetworkError>
}

struct ReadPostUseCase: ReadPostUseCaseProtocol {
    
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    
    init(provider: Requestable) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func execute(postId: Int) -> AnyPublisher<ReadPost, MacroNetwork.NetworkError> {
        let accessToken = KeyChainManager.load(key: KeyChainManager.Keywords.accessToken) ?? ""
        return provider.request(ReadEndPoint.read(postId: postId, accessToken: accessToken))
    }
}
