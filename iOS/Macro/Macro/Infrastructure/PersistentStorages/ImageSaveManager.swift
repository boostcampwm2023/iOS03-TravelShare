//
//  ImageSaveManager.swift
//  Macro
//
//  Created by 김경호 on 11/30/23.
//

import Combine
import Foundation
import MacroNetwork

class ImageSaveManager {
    private var cancellables = Set<AnyCancellable>()
    
    func convertImageDataToImageURL(imageDatas: [Data], completion: @escaping (([String]) -> Void)) {
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
