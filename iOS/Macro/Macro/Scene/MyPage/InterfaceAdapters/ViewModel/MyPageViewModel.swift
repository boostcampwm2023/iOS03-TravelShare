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
    
    // MARK: - init
    init() {
    }
    
    // MARK: - Input
    
    enum Input {
        
    }
    
    // MARK: - Output

    enum Output {
        case appleLoginCompleted
    }
    
    // MARK: - Methods
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
    
}
