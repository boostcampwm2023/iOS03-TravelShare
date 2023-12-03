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
    let sections = ["프로필", "나의 정보", "글 목록", "계정 관리"]
    let information = ["이름", "프로필 사진", "자기소개"]
    let post = ["작성한 글", "좋아요한 글"]
    let management = ["팔로우", "알림", "문의하기"]
    let patcher: PatchUseCase
    let searcher: SearchUseCase
    let comfirmer: ConfirmUseCase
    @Published var myInfo: UserProfile = UserProfile(email: "", name: "", imageUrl: "", introduce: "", followersNum: 0, followeesNum: 0)
    
    // MARK: - Init
    init(patcher: PatchUseCase, searcher: SearchUseCase, confirmer: ConfirmUseCase) {
        self.patcher = patcher
        self.searcher = searcher
        self.comfirmer = confirmer
    }
    
    // MARK: - Input
    
    enum Input {
        case completeButtonTapped(Int, String)
        case getMyUserData(String)
    }
    
    // MARK: - Output
    
    enum Output {
        case patchCompleted(Int, String)
        case sendMyUserData(UserProfile)
        case dissMissView
        case showAlert(String)
    }
    
}

// MARK: - Methods

extension MyPageViewModel {
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .completeButtonTapped(cellIndex, query):
                    self?.checkValidInput(cellIndex, query)
                    self?.getMyUserData(self?.email ?? "")
                case let .getMyUserData(email):
                    self?.getMyUserData(email)
                }
            }
            .store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func modifyInformation(_ cellIndex: Int, _ query: String) {
        patcher.patchUser(cellIndex: cellIndex, query: query).sink { _ in
        } receiveValue: { [weak self] _ in
            self?.outputSubject.send(.patchCompleted(cellIndex, query))
        }.store(in: &cancellables)
    }
    
    private func checkValidInput(_ cellIndex: Int, _ query: String) {
        let result: Result<Void, ConfirmError>
        switch cellIndex {
        case 0: result = self.comfirmer.confirmNickName(text: query)
        default: result = self.comfirmer.confirmIntroduce(text: query)
        }
        
        switch result {
        case .success:
            modifyInformation(cellIndex, query)
            outputSubject.send(.dissMissView)
        case .failure(let failure):
            outputSubject.send(.showAlert(failure.localizedDescription))
        }
    }
    
    private func getMyUserData(_ email: String) {
        searcher.searchUserProfile(query: email).sink { _ in
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.sendMyUserData(response))
            self?.myInfo = response
        }.store(in: &cancellables)
    }
}
