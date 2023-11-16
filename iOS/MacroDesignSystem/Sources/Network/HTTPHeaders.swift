//
//  HTTPHeaders.swift
//  
//
//  Created by 김나훈 on 11/16/23.
//

import Foundation

/// HTTP 요청시 필요한 headers를 관리하는 역할입니다.
public struct HTTPHeaders {
  
  /// HTTPHeader들을 여러개 가지고 있습니다.
  private var headers: [HTTPHeader]
  
  public init(headers: [HTTPHeader]) {
    self.headers = headers
  }
  
  var dictionary: [String: String] {
    let valueByName = headers.map {($0.name, $0.value)}
    return Dictionary(uniqueKeysWithValues: valueByName)
  }
}

// MARK: CustomStringConvertible

extension HTTPHeaders: CustomStringConvertible {
  public var description: String {
    return headers.map(\.description).joined(separator: "\n")
  }
}

// MARK: ExpressibleByArrayLiteral

extension HTTPHeaders: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: HTTPHeader...) {
    self.init(headers: elements)
  }
}

// MARK: ExpressibleByDictionaryLiteral

extension HTTPHeaders: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, String)...) {
    self.init(headers: elements.map({ HTTPHeader(name: $0, value: $1) }))
  }
}
