//
//  ReadViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import Foundation

class ReadViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // MARK: - init
    init() {
    }
    
    // MARK: - Input
    
    enum Input {
        case readPosts
        case searchUser(String)
    }
    
    // MARK: - Output

    enum Output {
        case updatePost(post: ReadPost)
        case navigateToProfileView(String)
    }
    
    // MARK: - Methods
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .readPosts:
                    self?.updateReadViewItems()
                case let .searchUser(userID):
                    self?.searchUser(id: userID)
                }
            }
            .store(in: &cancellables)
        return outputSubject.eraseToAnyPublisher()
    }
}

// MARK: - Methods
private extension ReadViewModel {
    func updateReadViewItems() {
        let mockPost = ReadPost(postId: 1, title: "김경호의 해피해피 코딩 라이프", contents: [
            PostContent(imageUrl: "https://mblogthumb-phinf.pstatic.net/MjAxNzA2MTRfMTM5/MDAxNDk3NDMzNzc3NzMz.bYz_7N23reM5QXP_MwApEZ6cMuP7HT0VF_FuE3j4bEYg.Lb1I_8WU9JFipAHpxlkSfHCGVnZ9ssflRaM1xgN2wGEg.JPEG.vazx1234/2017-06-14_18%3B45%3B09.JPG?type=w800", description: "해피해피 라이프"),
            PostContent(imageUrl: "https://mblogthumb-phinf.pstatic.net/MjAxNzA2MTRfMTM5/MDAxNDk3NDMzNzc3NzMz.bYz_7N23reM5QXP_MwApEZ6cMuP7HT0VF_FuE3j4bEYg.Lb1I_8WU9JFipAHpxlkSfHCGVnZ9ssflRaM1xgN2wGEg.JPEG.vazx1234/2017-06-14_18%3B45%3B09.JPG?type=w800", description: "해피해피 라이프2")
        ], writer: Writer(email: "ykm989@naver.com", name: "김경호", imageUrl: "https://mblogthumb-phinf.pstatic.net/MjAxNzA2MTRfMTM5/MDAxNDk3NDMzNzc3NzMz.bYz_7N23reM5QXP_MwApEZ6cMuP7HT0VF_FuE3j4bEYg.Lb1I_8WU9JFipAHpxlkSfHCGVnZ9ssflRaM1xgN2wGEg.JPEG.vazx1234/2017-06-14_18%3B45%3B09.JPG?type=w800"), route: [], hashtag: [], likeNum: 0, viewNum: 0, createdAt: nil, modifiedAt: nil, liked: false)
        outputSubject.send(.updatePost(post: mockPost))
    }
}

// MARK: - Metohds
private extension ReadViewModel {
    private func searchUser(id: String) {
        self.outputSubject.send(.navigateToProfileView(id))
    }
}
