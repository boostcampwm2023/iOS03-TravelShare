//
//  Session.swift
//  
//
//  Created by 김나훈 on 11/16/23.
//

import Foundation

public protocol Session {
  func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

// MARK: - URLSession + Session

extension URLSession: Session {
}
