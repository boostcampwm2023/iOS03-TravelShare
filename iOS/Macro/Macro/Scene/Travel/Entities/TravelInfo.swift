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
    var recordedPinnedLocations: [RecordedPinnedLocationInfomation]?
    let sequence: Int
    var startAt: Date?
    var endAt: Date?
}
