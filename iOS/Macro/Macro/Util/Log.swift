//
//  Log.swift
//  Macro
//
//  Created by 김나훈 on 12/1/23.
//

import Foundation
import OSLog

enum Log {
  static func make() -> Logger {
    .init(subsystem: Bundle.main.bundleIdentifier ?? "NONE", category: "")
  }
}
