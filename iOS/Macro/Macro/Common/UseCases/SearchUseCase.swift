//
//  SearchUseCase.swift
//  Macro
//
//  Created by 김나훈 on 11/22/23.
//

import Combine
import Foundation
import MacroNetwork

protocol SearchUseCase {
    func searchLocation(query: String, page: Int) -> AnyPublisher<[LocationDetail], NetworkError>
    func searchPost(query: String) -> AnyPublisher<[PostFindResponse], NetworkError>
    func searchMockPost(query: String, json: String) -> AnyPublisher<[PostFindResponse], NetworkError>
    func fetchHitPost() -> AnyPublisher<[PostFindResponse], NetworkError>
    func searchMockPost(json: String) -> AnyPublisher<[PostFindResponse], NetworkError>
    func searchUser(query: String) -> AnyPublisher<UserInfoResponse, NetworkError>
    func searchMockUserProfile(query: String, json: String) -> AnyPublisher<UserInfoResponse, NetworkError>
}

final class Searcher: SearchUseCase {
   
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    
    init(provider: Requestable) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func searchLocation(query: String, page: Int) -> AnyPublisher<[LocationDetail], MacroNetwork.NetworkError> {
        return provider.request(TravelEndPoint.search(query, page))
    }
    
    func searchPost(query: String) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.request(PostFindEndPoint.search(query))
    }
    
    func searchMockPost(query: String, json: String) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.mockRequest(PostFindEndPoint.search(query), url: json)
    }
    func fetchHitPost() -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.request(PostEndPoint.search)
    }
    
    func searchMockPost(json: String) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.mockRequest(PostEndPoint.search, url: json)
    }
    
    func searchUser(query: String) -> AnyPublisher<UserInfoResponse, MacroNetwork.NetworkError> {
        return provider.request(UserInfoEndPoint.search(query))
    }
    
    func searchMockUserProfile(query: String, json: String) -> AnyPublisher<UserInfoResponse, MacroNetwork.NetworkError> {
        return provider.mockRequest(UserInfoEndPoint.search(query), url: json)
    }
}
