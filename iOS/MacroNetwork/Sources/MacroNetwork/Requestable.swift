//
//  Requestable.swift
//  
//
//  Created by 김나훈 on 11/16/23.
//

import Combine
import Foundation

/// EndPoint를 사용해서 HTTP 요청시 구현해야 할 프로토콜
public protocol Requestable {
  func request<Target, Model>(_ target: Target) -> AnyPublisher<Model, NetworkError> where Target : EndPoint, Model: Decodable
    
    func mockRequest<Target, Model>(_ target: Target, url: String) -> AnyPublisher<Model, NetworkError> where Target : EndPoint, Model: Decodable
}
