//
//  TravelMO+CoreDataProperties.swift
//  Macro
//
//  Created by Byeon jinha on 12/4/23.
//
//

import Foundation
import CoreData


extension TravelMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TravelMO> {
        return NSFetchRequest<TravelMO>(entityName: "Travel")
    }

    @NSManaged public var endAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var recordedLocation: [[Double]]?
    @NSManaged public var sequence: Int16
    @NSManaged public var startAt: Date?
    @NSManaged public var recordedPinnedLocations: NSOrderedSet?

}

// MARK: Generated accessors for recordedPinnedLocations
extension TravelMO {

    @objc(insertObject:inRecordedPinnedLocationsAtIndex:)
    @NSManaged public func insertIntoRecordedPinnedLocations(_ value: RecordedPinnedLocationMO, at idx: Int)

    @objc(removeObjectFromRecordedPinnedLocationsAtIndex:)
    @NSManaged public func removeFromRecordedPinnedLocations(at idx: Int)

    @objc(insertRecordedPinnedLocations:atIndexes:)
    @NSManaged public func insertIntoRecordedPinnedLocations(_ values: [RecordedPinnedLocationMO], at indexes: NSIndexSet)

    @objc(removeRecordedPinnedLocationsAtIndexes:)
    @NSManaged public func removeFromRecordedPinnedLocations(at indexes: NSIndexSet)

    @objc(replaceObjectInRecordedPinnedLocationsAtIndex:withObject:)
    @NSManaged public func replaceRecordedPinnedLocations(at idx: Int, with value: RecordedPinnedLocationMO)

    @objc(replaceRecordedPinnedLocationsAtIndexes:withRecordedPinnedLocations:)
    @NSManaged public func replaceRecordedPinnedLocations(at indexes: NSIndexSet, with values: [RecordedPinnedLocationMO])

    @objc(addRecordedPinnedLocationsObject:)
    @NSManaged public func addToRecordedPinnedLocations(_ value: RecordedPinnedLocationMO)

    @objc(removeRecordedPinnedLocationsObject:)
    @NSManaged public func removeFromRecordedPinnedLocations(_ value: RecordedPinnedLocationMO)

    @objc(addRecordedPinnedLocations:)
    @NSManaged public func addToRecordedPinnedLocations(_ values: NSOrderedSet)

    @objc(removeRecordedPinnedLocations:)
    @NSManaged public func removeFromRecordedPinnedLocations(_ values: NSOrderedSet)

}

extension TravelMO : Identifiable {

}
