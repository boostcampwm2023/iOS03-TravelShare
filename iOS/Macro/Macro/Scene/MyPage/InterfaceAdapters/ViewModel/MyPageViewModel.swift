//
//  MyPageViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation

class MyPageViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    let email = TokenManager.extractEmailFromJWTToken()
    let sections = ["나의 정보", "글 목록", "계정 관리"]
    let information = ["이름", "프로필 사진", "자기소개"]
    let post = ["작성한 글", "좋아요한 글"]
    let management = ["팔로우", "알림", "문의하기"]
    let patcher: PatchUseCase
    let searcher: SearchUseCase
    var myInfo: UserProfile = UserProfile(email: "", name: "", imageUrl: "", introduce: "", followersNum: 0, followeesNum: 0)
    
    // MARK: - init
    init(patcher: PatchUseCase, searcher: SearchUseCase) {
        self.patcher = patcher
        self.searcher = searcher
    }
    
    // MARK: - Input
    
    enum Input {
        case completeButtonPressed(Int, String)
        case getMyUserData(String)
    }
    
    // MARK: - Output
    
    enum Output {
        case patchCompleted(Int, String)
        case sendMyUserData(UserProfile)
    }
    
    // MARK: - Methods
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .completeButtonPressed(cellIndex, query):
                    self?.modifyInformation(cellIndex, query)
                case let .getMyUserData(email):
                    self?.getMyUserData(email)
                }
            }
            .store(in: &cancellables)
            
        return outputSubject.eraseToAnyPublisher()
    }
    
    func modifyInformation(_ cellIndex: Int, _ query: String) {
       
        patcher.patchUser(cellIndex: cellIndex, query: query).sink { completion in
            print(completion)
        } receiveValue: { [weak self] response in
            print(response)
            self?.outputSubject.send(.patchCompleted(cellIndex, query))
        }.store(in: &cancellables)
    }
    
    func getMyUserData(_ email: String) {
        searcher.searchUserProfile(query: email).sink { completion in
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.sendMyUserData(response))
            self?.myInfo = response
        }.store(in: &cancellables)
    }
}
