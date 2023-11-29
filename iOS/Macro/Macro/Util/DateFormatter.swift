//
//  DateFormatter.swift
//  Macro
//
//  Created by Byeon jinha on 11/29/23.
//

import Foundation

extension Date {
    static func transDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd h:mma"
        return dateFormatter.string(from: date)
    }
}
