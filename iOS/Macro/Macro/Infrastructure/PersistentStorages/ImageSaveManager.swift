//
//  ImageSaveManager.swift
//  Macro
//
//  Created by 김경호 on 11/30/23.
//

import Combine
import Foundation
import MacroNetwork

struct ImageSaveManager {
    static func convertImageDataToImageURL(imageDatas: [Data], cancellables: inout Set<AnyCancellable>, completion: @escaping (([String]) -> Void)) {
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
                .store(in: &cancellables)
        }
    }
}
