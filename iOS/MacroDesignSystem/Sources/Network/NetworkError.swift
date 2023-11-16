//
//  NetworkError.swift
//  
//
//  Created by 김나훈 on 11/16/23.
//

import Foundation

public enum NetworkError: Error {
  /// 잘못된 URL일 때
  case invalidURL(url: String)
  
  /// 불명확한 Request 오류
  case invalidURLRequest
  
  /// 잘못된 HTTP 응답이 왔을 때
  case invalidHTTPResponse
  
  /// 잘못된 Request 요청
  ///
  /// 400번대 에러가 발생했을 때 해당 에러가 발생합니다.
  case invalidRequest
  
  /// Server에서 에러가 발생한 경우
  ///
  /// 500번대 에러가 발생했을 때 해당 에러가 발생합니다.
  case invalidServer
  
  /// 디코딩 중에 에러가 발생한 경우
  case decodingError
  
  /// 알 수 없는 에러
  case unknownError
}
