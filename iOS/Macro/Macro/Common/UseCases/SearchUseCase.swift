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
    /// 특정 장소를 검색했을 때 받아오는 검색 결과
    func searchLocation(query: String, page: Int) -> AnyPublisher<[LocationDetail], NetworkError>
    
    /// 특정 검색어가 제목에 포함되었는지를 검색하는 결과
    func searchPost(query: String) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 특정 검색어가 해당 json 파일 list의 제목에 포함되는지 검색
    func searchMockPost(query: String, json: String) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 가장 인기있는 게시물들을 받아오는 작업
    func fetchHitPost() -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 홈 화면의 게시글들을 해당 json 파일에서 모두 불러오는 작업
    func searchMockPost(json: String) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 특정 사용자의 id를 검색하면, 해당 사용자의 게시글들을 모두 불러옴
    func searchUserProfile(query: String) -> AnyPublisher<ProfileGetResponse, NetworkError>
    
    /// 특정 사용자의 id를 검색하면, 해당 json 파일 내의 해당 사용자의 게시글 모두 불러옴
    func searchMockUserProfile(query: String, json: String) -> AnyPublisher<ProfileGetResponse, NetworkError>
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
    
    func searchUserProfile(query: String) -> AnyPublisher<ProfileGetResponse, MacroNetwork.NetworkError> {
        return provider.request(UserInfoEndPoint.search(query))
    }
    
    func searchMockUserProfile(query: String, json: String) -> AnyPublisher<ProfileGetResponse, MacroNetwork.NetworkError> {
        return provider.mockRequest(UserInfoEndPoint.search(query), url: json)
    }
}
