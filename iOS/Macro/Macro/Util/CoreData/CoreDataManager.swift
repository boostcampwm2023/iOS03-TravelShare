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
    
    func saveTravel(id: String, recordedLocation: [[Double]], recordedPindedLocation: [[Double]], sequence: Int) {
        let request = NSFetchRequest<Locations>(entityName: Label.entityName)
        do {
            let locations = try coreDataStack.managedContext.fetch(request)
            let location = NSEntityDescription.insertNewObject(forEntityName: Label.entityName, into: coreDataStack.managedContext)
            location.setValue(id, forKey: Label.id)
            location.setValue(recordedLocation, forKey: Label.recordedLocation)
            location.setValue(recordedPindedLocation, forKey: Label.recordedPindedLocation)
            location.setValue(sequence, forKey: Label.squence)
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
    }
}
