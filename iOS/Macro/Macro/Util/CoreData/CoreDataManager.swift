//
//  CoreDataManager.swift
//  Macro
//
//  Created by Byeon jinha on 11/27/23.
//

import CoreData
import UIKit

final class CoreDataManager {
    // MARK: - 사용 방법: CoreDataManager.shared.countLocations()
    static let shared: CoreDataManager = CoreDataManager()
    
    var coreDataStack = CoreDataStack(modelName: Label.modelName)
    
    func fetchTravel(completion: @escaping ([TravelInfo]?) -> Void) throws {
        let request = NSFetchRequest<TravelMO>(entityName: EntityName.travel)
        do {
            let sort = NSSortDescriptor(key: Label.sequence, ascending: false)
            request.sortDescriptors = [sort]
            let travels = try coreDataStack.managedContext.fetch(request)

            let travelInfoArray: [TravelInfo] = try travels.map({
                guard let id = $0.id,
                      let recordedLocation = $0.recordedLocation,
                      let recordedPinnedLocations = $0.recordedPinnedLocations
                else {
                    throw CoreDataError.intputError("mapping error")
                }
                
                guard let pinnedLocationInfo = recordedPinnedLocations.array as? [RecordedPinnedLocationMO] else { throw CoreDataError.intputError("mapping error") }
     
                let recordedPinnedLocationInfomationArray: [RecordedPinnedLocationInfomation] = pinnedLocationInfo.map {
                    RecordedPinnedLocationInfomation(
                        placeId: $0.placeId,
                        placeName: $0.placeName,
                        phoneNumber: $0.phoneNumber,
                        category: $0.category,
                        address: $0.address,
                        roadAddress: $0.roadAddress,
                        coordinate: PinnedLocation(latitude: $0.coordinate?[0] ?? 0, longitude: $0.coordinate?[1] ?? 0)
                    )
                }
                
                return TravelInfo(id: id,
                                  recordedLocation: recordedLocation,
                                  recordedPinnedLocations: recordedPinnedLocationInfomationArray,
                                  sequence: Int($0.sequence),
                                  startAt: $0.startAt,
                                  endAt: $0.endAt)
            })
            completion(travelInfoArray)
        } catch {
            completion(nil)
        }
    }
    
    func saveTravel(id: String,
                    recordedLocation: [[Double]],
                    recordedPinnedLocations: [RecordedPinnedLocationInfomation]?,
                    sequence: Int,
                    startAt: Date,
                    endAt: Date) {
        
        let request = NSFetchRequest<TravelMO>(entityName: EntityName.travel)
        
        let travelObject = NSEntityDescription.insertNewObject(forEntityName: EntityName.travel, into: coreDataStack.managedContext)
        travelObject.setValue(id, forKey: Label.id)
        travelObject.setValue(recordedLocation, forKey: Label.recordedLocation)
        travelObject.setValue(sequence, forKey: Label.sequence)
        travelObject.setValue(startAt, forKey: Label.startAt)
        travelObject.setValue(endAt, forKey: Label.endAt)
        
        if let recordedPinnedLocations = recordedPinnedLocations {
            for recordedPinnedLocation in recordedPinnedLocations {
                
                guard let recordedPinnedLocationObejct = NSEntityDescription.insertNewObject(forEntityName: EntityName.recordedPinnedLocation, into: coreDataStack.managedContext) as? RecordedPinnedLocationMO else { return }
                recordedPinnedLocationObejct.id = id
                recordedPinnedLocationObejct.category = recordedPinnedLocation.category
                if let recordedPinnedCoordinate = recordedPinnedLocation.coordinate { recordedPinnedLocationObejct.coordinate = [recordedPinnedCoordinate.latitude, recordedPinnedCoordinate.longitude]
                }
                recordedPinnedLocationObejct.address = recordedPinnedLocation.address
                recordedPinnedLocationObejct.phoneNumber =  recordedPinnedLocation.phoneNumber
                recordedPinnedLocationObejct.placeId = recordedPinnedLocation.placeId
                recordedPinnedLocationObejct.placeName = recordedPinnedLocation.placeName
                recordedPinnedLocationObejct.roadAddress = recordedPinnedLocation.roadAddress
                
                (travelObject as? TravelMO)?.addToRecordedPinnedLocations(recordedPinnedLocationObejct)
            }
        }
        
        do {
            _ = try coreDataStack.managedContext.fetch(request)
            coreDataStack.saveContext()
        } catch {
            Log.make().error("\(error)")
        }
    }
    
    func deleteTravel(travelUUID: String) {
        let request = NSFetchRequest<TravelMO>(entityName: EntityName.travel)
        do {
            let travels = try coreDataStack.managedContext.fetch(request)
            for travel in travels where travel.id == travelUUID {
                self.coreDataStack.managedContext.delete(travel)
                break
            }
        } catch {
        }
        coreDataStack.saveContext()
    }
    
    func calculateNextSequence() throws -> Int {
        let request = NSFetchRequest<TravelMO>(entityName: EntityName.travel)
        request.propertiesToFetch = ["sequence"]
        request.sortDescriptors = [NSSortDescriptor(key: "sequence", ascending: false)]
        
        do {
            let travels = try coreDataStack.managedContext.fetch(request)
            if let maxSequence = travels.first?.sequence {
                return Int(maxSequence) + 1
            } else {
                return 1
            }
        } catch {
            throw CoreDataError.intputError("Failed to calculate next sequence")
        }
    }
}

// MARK: Metrics

extension CoreDataManager {
    enum Label {
        static let modelName: String = "Macro"
        
        static let id: String = "id"
        static let recordedLocation: String = "recordedLocation"
        static let recordedPinnedLocation: String = "recordedPinnedLocation"
        static let sequence: String = "sequence"
        static let startAt: String = "startAt"
        static let endAt: String = "endAt"
    }
    
    enum EntityName {
        static let travel: String = "Travel"
        static let recordedPinnedLocation: String = "RecordedPinnedLocation"
    }
}

enum CoreDataError: Error {
    case intputError(String)
}
