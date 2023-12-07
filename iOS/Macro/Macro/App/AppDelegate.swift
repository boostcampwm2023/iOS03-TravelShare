//
//  AppDelegate.swift
//  Macro
//
//  Created by 김경호 on 11/13/23.
//

import CoreData
import CoreLocation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Core Data stack

     lazy var persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "Model")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     }()

     // MARK: - Core Data Saving support

     func saveContext () {
         let context = persistentContainer.viewContext
         if context.hasChanges {
             do {
                 try context.save()
             } catch {
                 // Replace this implementation with code to handle the error appropriately.
                 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 let nserror = error as NSError
                 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
             }
         }
     }
}

