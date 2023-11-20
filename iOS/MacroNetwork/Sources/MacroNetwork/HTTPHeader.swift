//
//  HTTPHeader.swift
//  
//
//  Created by 김나훈 on 11/16/23.
//

import Foundation

/// HTTP 요청시 필요한 Header입니다.
public struct HTTPHeader {
  
  /// HTTPHeader 이름
  public let name: String
  
  /// HTTPHeader에 대응되는 값
  public let value: String
  
  public init(name: String, value: String) {
    self.name = name
    self.value = value
  }
}

extension HTTPHeader: CustomStringConvertible {
  public var description: String {
    return "\(name) : \(value)"
  }
}
