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
                        print(12123)
                    } else if imageURLs.count == imageDatas.count {
                        completion(imageURLs)
                        print(12145)
                    }
                } receiveValue: { imageURLResponse in
                    imageURLs.append(imageURLResponse.url)
                    print(imageURLResponse)
                }
                .store(in: &cancellables)
        }
    }
}
