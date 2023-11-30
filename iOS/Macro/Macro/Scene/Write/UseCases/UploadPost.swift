//
//  UploadPost.swift
//  Macro
//
//  Created by 김경호 on 11/29/23.
//

import Combine
import Foundation
import MacroNetwork

protocol UploadPostUseCase {
    func execute(post: Post, token: String) -> AnyPublisher<PostUploadResponse, MacroNetwork.NetworkError>
}

struct UploadPost: UploadPostUseCase {
    
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    
    init(provider: Requestable) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func execute(post: Post, token: String) -> AnyPublisher<PostUploadResponse, MacroNetwork.NetworkError> {
        return provider.request(PostUploadEndPoint.uploadPost(post: post, token: token))
    }
}
