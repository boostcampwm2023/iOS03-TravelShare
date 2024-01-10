//
//  ImageSaveManager.swift
//  Macro
//
//  Created by 김경호 on 11/30/23.
//

import Combine
import Foundation
import MacroNetwork

final class ImageSaveManager {
    static let shared = ImageSaveManager()
    private init() {}
    private var cancellables = Set<AnyCancellable>()
    
    // 이미지 데이터가 한개 인 경우
    func convertImageDataToImageURL(imageData: Data, completion: @escaping ((String) -> Void)) {
        let provider = APIProvider(session: URLSession.shared)
        let uploadImageUseCase = UploadImage(provider: provider)
        
        uploadImageUseCase.execute(imageData: imageData)
            .receive(on: DispatchQueue.global())
            .sink { result in
                if case let .failure(error) = result {
                    debugPrint("Image Upload Fail : ", error)
                }
            } receiveValue: { imageURLResponse in
                if !imageURLResponse.url.isEmpty {
                    completion(imageURLResponse.url)
                }
            }
            .store(in: &self.cancellables)
    }
    
    // Image Data가 여러개 있을 경우
    func convertImageDatasToImageURLs(imageDatas: [Data], completion: @escaping (([String]) -> Void)) {
        guard !imageDatas.isEmpty else {
            completion([])
            return
        }
        
        let provider = APIProvider(session: URLSession.shared)
        let uploadImageUseCase = UploadImage(provider: provider)
        var imageURLs = [String]()
        imageDatas.forEach { imageData in
            uploadImageUseCase.execute(imageData: imageData)
                .receive(on: DispatchQueue.global())
                .sink { result in
                    if case let .failure(error) = result {
                        debugPrint("Image Upload Fail : ", error)
                    } else if imageURLs.count == imageDatas.count {
                        completion(imageURLs)
                    }
                } receiveValue: { imageURLResponse in
                    imageURLs.append(imageURLResponse.url)
                }
                .store(in: &self.cancellables)
        }
    }
}
