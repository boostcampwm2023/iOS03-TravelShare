//
//  ReportUseCase.swift
//  Macro
//
//  Created by Byeon jinha on 12/10/23.
//

import Combine
import Foundation
import MacroNetwork

protocol ReportUseCase {
    func reportPost(postId: String, title: String, description: String) -> AnyPublisher<ReportResponse, NetworkError>
}

final class Reporter: ReportUseCase {
    
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    init(provider: Requestable) {
        self.provider = provider
    }
    
    func reportPost(postId: String, title: String, description: String) -> AnyPublisher<ReportResponse, MacroNetwork.NetworkError> {
        return provider.request(ReportEndPoint.report(postId: postId, title: title, description: description))
    }
}
