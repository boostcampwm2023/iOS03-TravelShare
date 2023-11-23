//
//  UploadImageUseCases.swift
//  Macro
//
//  Created by 김경호 on 11/24/23.
//

import Combine
import Foundation
import MacroNetwork

protocol UploadImageUseCases {
    func execute(imageData: Data) -> AnyPublisher<ImageURLResponse, MacroNetwork.NetworkError>
}

struct UploadImage: UploadImageUseCases {
    
    // MARK: - Properties
    
    private let provider: Requestable
    
    // MARK: - Init
    
    init(provider: Requestable) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func execute(imageData: Data) -> AnyPublisher<ImageURLResponse, MacroNetwork.NetworkError> {
        return provider.request(ImageUploadEndPoint.uploadImage(imageData: imageData))
    }
}
