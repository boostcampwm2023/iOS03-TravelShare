//
//  RecordedPinnedLocationMO+CoreDataProperties.swift
//  Macro
//
//  Created by Byeon jinha on 12/4/23.
//
//

import Foundation
import CoreData


extension RecordedPinnedLocationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordedPinnedLocationMO> {
        return NSFetchRequest<RecordedPinnedLocationMO>(entityName: "RecordedPinnedLocation")
    }

    @NSManaged public var address: String?
    @NSManaged public var category: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var placeId: String?
    @NSManaged public var placeName: String?
    @NSManaged public var roadAddress: String?
    @NSManaged public var id: String?
    @NSManaged public var coordinate: [Double]?
    @NSManaged public var travel: TravelMO?

}

extension RecordedPinnedLocationMO : Identifiable {

}

