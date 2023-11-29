//
//  CoreDataManager.swift
//  Macro
//
//  Created by Byeon jinha on 11/27/23.
//

import CoreData
import UIKit

class CoreDataManager {
    // MARK: - 사용 방법: CoreDataManager.shared.countLocations()
    static let shared: CoreDataManager = CoreDataManager()
    
    var coreDataStack = CoreDataStack(modelName: Label.modelName)
    
    func fetchTravel() -> [Travel] {
        let request = NSFetchRequest<Travel>(entityName: "Travel")
        do {
            let travels = try coreDataStack.managedContext.fetch(request)
            return travels
        } catch {
            print("-----fetchLocationsError-----")
            return []
        }
    }
    
    func saveTravel(id: String,
                    recordedLocation: [[Double]],
                    recordedPindedLocation: [[String: [Double?]]],
                    sequence: Int,
                    startAt: Date,
                    endAt: Date) {
        let request = NSFetchRequest<Travel>(entityName: Label.entityName)
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            let location = NSEntityDescription.insertNewObject(forEntityName: Label.entityName, into: coreDataStack.managedContext)
            location.setValue(id, forKey: Label.id)
            location.setValue(recordedLocation, forKey: Label.recordedLocation)
            location.setValue(recordedPindedLocation, forKey: Label.recordedPindedLocation)
            location.setValue(sequence, forKey: Label.squence)
            location.setValue(startAt, forKey: Label.startAt)
            location.setValue(endAt, forKey: Label.endAt)
            coreDataStack.saveContext()
        } catch {
           // TODO: os log 만들고 실패시 log를 찍도록 작업해요
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
        static let squence: String = "recordedPindedLocation"
        static let startAt: String = "startAt"
        static let endAt: String = "endAt"
    }
}
