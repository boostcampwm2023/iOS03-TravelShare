//
//  HTTPParameter.swift
//  
//
//  Created by 김나훈 on 11/16/23.
//

import Foundation

/// 통신 요청할 때 필요한 Parameter
public enum HTTPParameter {
  /// 빈 평문입니다
  ///
  /// 아무런 정보값 없이 요청할 때 사용합니다.
  case plain
  
  /// query를 설정합니다
  ///
  /// query 문으로 요청값을 설정하고 싶을 때 사용합니다.
  case query(Encodable)
  
  /// body를 설정합니다
  ///
  /// body를 담아 보내야 하는 경우에 사용합니다
  case body(Encodable)
  
  /// Dictionary가 아닌 body를 설정
  ///
  /// Dictionary Type이 아닌 Data를 body에 담아 보내야 하는 경우 사용
  case data(Data)
}
