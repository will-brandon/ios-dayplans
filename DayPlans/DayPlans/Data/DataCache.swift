//
//  DataCache.swift
//  DayPlans
//
//  Created by Will Brandon on 9/21/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataCache {
    
    typealias ManagedObjectManipulation = (DataCacheManagedObject) -> Void
    
    static let current = DataCache()
    
    private init() {}
    
    // MARK: - Core Data Fetch & Manipulate
    
    private func fetchManagedObject() -> DataCacheManagedObject? {
        return (try? AppDelegate.current?.coreDataContext.fetch(DataCacheManagedObject.fetchRequest()))?.first
    }
    
    private func managedObject() -> DataCacheManagedObject? {
        if let managedObject = fetchManagedObject() {
            return managedObject
        } else if let appDelegate = AppDelegate.current {
            return DataCacheManagedObject(context: appDelegate.coreDataContext)
        }
        return nil
    }
    
    @discardableResult private func tryManipulateManagedObject(_ managedObjectManipulation: ManagedObjectManipulation) -> Bool {
        if let managedObject = managedObject() {
            managedObjectManipulation(managedObject)
            return AppDelegate.current?.trySaveCoreDataContext() ?? false
        }
        return false
    }
    
    // MARK: - Cacheable Components Fetch, Save & Clear
    
    func fetchUserPreferences() -> UserPreferences? {
        if let managedObject = managedObject(), let serializedUserPreferencesData = managedObject.serializedUserPreferencesData {
            return Serializer.current.deserialize(decodableType: UserPreferencesData.self, serializedObject: serializedUserPreferencesData)?.userPreferences()
        }
        return nil
    }
    
    func fetchPlanner() -> Planner? {
        if let managedObject = managedObject(), let serializedPlannerData = managedObject.serializedPlannerData {
            return Serializer.current.deserialize(decodableType: PlannerData.self, serializedObject: serializedPlannerData)?.planner()
        }
        return nil
    }
    
    @discardableResult func trySave(userPreferences: UserPreferences) -> Bool {
        return tryManipulateManagedObject {
            (managedObject) in
            managedObject.serializedUserPreferencesData = Serializer.current.serialize(encodable: UserPreferencesData(fromUserPreferences: userPreferences))
        }
    }
    
    @discardableResult func trySave(planner: Planner) -> Bool {
        return tryManipulateManagedObject {
            (managedObject) in
            managedObject.serializedPlannerData = Serializer.current.serialize(encodable: PlannerData(fromPlanner: planner))
        }
    }
    
    @discardableResult func tryClearUserPreferences() -> Bool {
        return tryManipulateManagedObject {
            (managedObject) in
            managedObject.serializedUserPreferencesData = nil
        }
    }
    
    @discardableResult func tryClearPlanner() -> Bool {
        return tryManipulateManagedObject {
            (managedObject) in
            managedObject.serializedPlannerData = nil
        }
    }
    
    @discardableResult func tryClear() -> Bool { tryClearUserPreferences() && tryClearPlanner() }
    
}
