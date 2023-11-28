//
//  TravelInfo.swift
//  Macro
//
//  Created by Byeon jinha on 11/27/23.
//

import Foundation

struct TravelInfo {
    let id: String
    var recordedLocation: [[Double]]?
    var recordedPindedLocation: [[Double]]?
    let sequence: Int16
    var startAt: Date?
    var endAt: Date?
}
