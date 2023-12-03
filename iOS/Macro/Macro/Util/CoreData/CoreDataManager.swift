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
        let request = NSFetchRequest<Travel>(entityName: "Travel")
        do {
            var travels = try coreDataStack.managedContext.fetch(request)
            travels.sort { $0.sequence > $1.sequence }
            let travelInfoArray: [TravelInfo] = try travels.map({
                guard let id = $0.id,
                      let recordedLocation = $0.recordedLocation,
                      let recordedPindedLocation = $0.recordedPindedLocation
                else {
                    throw CoreDataError.intputError("d")
                }
                
                return TravelInfo(id: id,
                                  recordedLocation: recordedLocation,
                                  recordedPindedInfo: recordedPindedLocation,
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
                    recordedPindedLocation: [[String: [Double]]]?,
                    sequence: Int,
                    startAt: Date,
                    endAt: Date) {
        let request = NSFetchRequest<Travel>(entityName: Label.entityName)
        
        do {
            _ = try coreDataStack.managedContext.fetch(request)
            let travel = NSEntityDescription.insertNewObject(forEntityName: Label.entityName, into: coreDataStack.managedContext)
            travel.setValue(id, forKey: Label.id)
            travel.setValue(recordedLocation, forKey: Label.recordedLocation)
            travel.setValue(recordedPindedLocation, forKey: Label.recordedPindedLocation)
            travel.setValue(sequence, forKey: Label.sequence)
            travel.setValue(startAt, forKey: Label.startAt)
            travel.setValue(endAt, forKey: Label.endAt)
            coreDataStack.saveContext()
        } catch {
            Log.make().error("\(error)")
        }
    }
    
    func deleteTravel(travelUUID: String) {
        let request = NSFetchRequest<Travel>(entityName: "Travel")
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
        let request = NSFetchRequest<Travel>(entityName: "Travel")
        request.propertiesToFetch = ["sequence"]
        request.sortDescriptors = [NSSortDescriptor(key: "sequence", ascending: false)] // sequence 내림차순으로 정렬

        do {
            let travels = try coreDataStack.managedContext.fetch(request)
            if let maxSequence = travels.first?.sequence {
                return Int(maxSequence) + 1 // 다음 시퀀스는 최대값 + 1
            } else {
                return 1 // 시퀀스가 없을 경우 1부터 시작
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
        static let entityName: String = "Travel"
        
        static let id: String = "id"
        static let recordedLocation: String = "recordedLocation"
        static let recordedPindedLocation: String = "recordedPindedLocation"
        static let sequence: String = "sequence"
        static let startAt: String = "startAt"
        static let endAt: String = "endAt"
    }
}

enum CoreDataError: Error {
    case intputError(String)
}
