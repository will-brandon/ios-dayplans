//
//  AppDelegate.swift
//  DayPlans
//
//  Created by Will Brandon on 7/15/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    class var current: AppDelegate? { UIApplication.shared.delegate as? AppDelegate }
    
    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationManager.current.requestNotificationAuthorization()
        if Properties.SHOULD_CLEAR_DATA_CACHE_AT_LAUNCH {
            if !DataCache.current.tryClear() {
                return false
            }
        }
        if Properties.SHOULD_EXECUTE_TESTS {
            Tester.executeTests()
        }
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data

    lazy var coreDataPersistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DayPlans")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if error != nil {
                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                Console.error(error!)
            }
        })
        return container
    }()
    
    var coreDataContext: NSManagedObjectContext { coreDataPersistentContainer.viewContext }

    func trySaveCoreDataContext() -> Bool {
        if coreDataContext.hasChanges {
            do {
                try coreDataContext.save()
            } catch {
                Console.error(error)
                return false
            }
            return true
        }
        return false
    }

}
