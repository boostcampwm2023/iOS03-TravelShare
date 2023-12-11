//
//  MyPageViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation

final class MyPageViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    let email = TokenManager.extractEmailFromJWTToken()
    let sections = ["프로필", "나의 정보", "글 목록", "계정 관리"]
    let information = ["이름", "프로필 사진", "자기소개"]
    let post = ["작성한 글"/*, "좋아요한 글"*/]
    let management = ["팔로우", /*"알림",*/ "문의하기", "로그아웃", "회원탈퇴"]
    var followType: FollowType = .followees
    var followList: [FollowList] = []
    let patcher: PatchUseCase
    let revoker: RevokeUseCase
    let searcher: SearchUseCase
    let comfirmer: ConfirmUseCase
    let uploader: UploadImageUseCases
    @Published var myInfo: UserProfile = UserProfile(email: "", name: "", imageUrl: "", introduce: "", followersNum: 0, followeesNum: 0, followee: false, follower: false)
    
    // MARK: - Init
    init(patcher: PatchUseCase, 
         searcher: SearchUseCase,
         confirmer: ConfirmUseCase,
         uploader: UploadImageUseCases,
         revoker: RevokeUseCase
    ) {
        self.patcher = patcher
        self.searcher = searcher
        self.comfirmer = confirmer
        self.uploader = uploader
        self.revoker = revoker
    }
    
    // MARK: - Input
    
    enum Input {
        case completeButtonTapped(Int, String)
        case getMyUserData(String)
        case selectImage(Data)
        case getFollowInformation
        case appleLogout(identityToken: String, authorizationCode: String, accessToken: String)
        case appleRevoke(identityToken: String, authorizationCode: String, accessToken: String)
    }
    
    // MARK: - Output
    
    enum Output {
        case patchCompleted(Int, String)
        case sendMyUserData(UserProfile)
        case dissMissView
        case showAlert(String)
        case profileEdit(String)
        case sendFollowersCount(Int)
        case sendFolloweesCount(Int)
        case reloadData
        case completeRevoke
        case failureRevoke
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
                case let .getMyUserData(email):
                    self?.getMyUserData(email)
                case let .selectImage(data):
                    self?.uploadImage(data)
                case .getFollowInformation:
                    self?.getFollowInformation()
                case let .appleLogout(identityToken, authorizationCode, accessToken):
                    self?.appleLogout(identityToken, authorizationCode, accessToken)
                case .appleRevoke(identityToken: let identityToken, authorizationCode: let authorizationCode, accessToken: let accessToken):
                    self?.appleRevoke(identityToken, authorizationCode, accessToken)
                }
            }
            .store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }

}

private extension MyPageViewModel {
    
    func appleLogout(_ identityToken: String, _ authorizationCode: String, _ accessToken: String) {
    }
    
    func appleRevoke(_ identityToken: String, _ authorizationCode: String, _ accessToken: String) {
        revoker.withdraw(identityToken: identityToken, authorizationCode: authorizationCode, accessToken: accessToken)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    Log.make().error("\(error)")
                    self?.outputSubject.send(.failureRevoke)
                case .finished:
                    self?.outputSubject.send(.completeRevoke)
                }
        } receiveValue: { [weak self] _ in
            self?.outputSubject.send(.completeRevoke)
        }.store(in: &cancellables)
    }
    
    func getFollowInformation() {
        
        switch self.followType {
        case .followees: self.followType = .followers
        case .followers: self.followType = .followees
        }
        
        searcher.searchUserFollow(type: .followees, query: email ?? "").sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            if self.followType == .followees {
                self.followList = response
                outputSubject.send(.reloadData)
            }
            outputSubject.send(.sendFolloweesCount(response.count))
        }.store(in: &cancellables)
        
        searcher.searchUserFollow(type: .followers, query: email ?? "").sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            if self.followType == .followers {
                self.followList = response
                outputSubject.send(.reloadData)
            }
            outputSubject.send(.sendFollowersCount(response.count))
        }.store(in: &cancellables)

    }
    
    func uploadImage(_ data: Data) {
        uploader.execute(imageData: data).sink { completion in
            if case let .failure(error) = completion {
                Log.make().error("\(error)")
            }
        } receiveValue: {  [weak self] response in
            self?.outputSubject.send(.profileEdit(response.url))
            self?.modifyInformation(1, response.url)
        }.store(in: &cancellables)
    }
    
    func modifyInformation(_ cellIndex: Int, _ query: String) {
        patcher.patchUser(cellIndex: cellIndex, query: query).sink { _ in
        } receiveValue: { [weak self] _ in
            switch cellIndex {
            case 0:
                self?.myInfo.name = query
            case 1:
                self?.myInfo.imageUrl = query
            default: self?.myInfo.introduce = query
            }
            self?.getMyUserData(self?.email ?? "")
        }.store(in: &cancellables)
    }
    
    func checkValidInput(_ cellIndex: Int, _ query: String) {
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
    
    func getMyUserData(_ email: String) {
        searcher.searchUserProfile(query: email).sink { _ in
        } receiveValue: { [weak self] response in
            self?.outputSubject.send(.sendMyUserData(response))
            self?.myInfo = response
        }.store(in: &cancellables)
    }

}
