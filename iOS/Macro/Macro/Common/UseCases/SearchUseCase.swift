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
    
    /// 특정 사용자의 게시글들을 전부 불러오는 함수
    func searchPost(query: String, postCount: Int) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 특정 검색어가 해당 json 파일 list의 제목에 포함되는지 검색
    func searchMockPost(query: String, json: String) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 가장 인기있는 게시물들을 받아오는 작업
    func fetchHitPost(postCount: Int) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 홈 화면의 게시글들을 해당 json 파일에서 모두 불러오는 작업
    func searchMockPost(json: String) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 특정 사용자의 id를 검색하면, 해당 사용자의 정보를 불러옴
    func searchUserProfile(query: String) -> AnyPublisher<UserProfile, NetworkError>
    
    /// 특정 사용자의 id를 검색하면, 해당 json 파일 내의 해당 사용자의 게시글 모두 불러옴
    func searchMockUserProfile(query: String, json: String) -> AnyPublisher<ProfileGetResponse, NetworkError>

    /// 특정 제목으로 게시글을 검색
    func searchPostTitle(query: String, postCount: Int) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// 특정 단어로 유저이름을 검색
    func searchAccountWord(query: String) -> AnyPublisher<[UserProfile], NetworkError>
    
    /// postId를 기준으로, 해당 장소를 다녀간 게시글들을 보여줌
    func searchRelatedPost(query: String, postCount: Int) -> AnyPublisher<[PostFindResponse], NetworkError>
    
    /// postId를 기준으로, 해당 장소와 가장 많이 함께 간 장소를 보여줌
    func searchRelatedLocation(query: String) -> AnyPublisher<[RelatedLocation], NetworkError>
    
    /// 해당 유저의 follower, 혹은 followee 정보를 가져옴
    func searchUserFollow(type: FollowType, query: String) -> AnyPublisher<[FollowList], NetworkError>
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
    
    func searchPost(query: String, postCount: Int) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.request(PostSearchEndPoint.search(query, postCount))
    }
    
    func searchMockPost(query: String, json: String) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.mockRequest(PostFindEndPoint.searchPost(query, 0), url: json)
    }
    
    func fetchHitPost(postCount: Int) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.request(PostEndPoint.search(postCount))
    }
    
    func searchMockPost(json: String) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.mockRequest(PostEndPoint.search(0), url: json)
    }
    
    func searchUserProfile(query: String) -> AnyPublisher<UserProfile, MacroNetwork.NetworkError> {
        return provider.request(UserInfoEndPoint.search(query))
    }
    
    func searchMockUserProfile(query: String, json: String) -> AnyPublisher<ProfileGetResponse, MacroNetwork.NetworkError> {
        return provider.mockRequest(UserInfoEndPoint.search(query), url: json)
    }
    
    func searchPostTitle(query: String, postCount: Int) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.request(PostFindEndPoint.searchPost(query, postCount))
    }
    
    func searchAccountWord(query: String) -> AnyPublisher<[UserProfile], MacroNetwork.NetworkError> {
        return provider.request(PostFindEndPoint.searchAccount(query))
    }
    
    func searchRelatedPost(query: String, postCount: Int) -> AnyPublisher<[PostFindResponse], MacroNetwork.NetworkError> {
        return provider.request(LocationInfoEndPoint.relatedPost(query, postCount))
    }
    
    func searchRelatedLocation(query: String) -> AnyPublisher<[RelatedLocation], MacroNetwork.NetworkError> {
        return provider.request(LocationInfoEndPoint.relatedLocation(query))
    }
    
    func searchUserFollow(type: FollowType, query: String) -> AnyPublisher<[FollowList], MacroNetwork.NetworkError> {
        return provider.request(FollowListEndPoint.followType(type, query))
    }
}
