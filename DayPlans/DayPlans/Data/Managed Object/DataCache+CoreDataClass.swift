//
//  DataCache+CoreDataClass.swift
//  DayPlans
//
//  Created by Will Brandon on 10/7/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//
//

import Foundation
import CoreData

// Note: Exposing to Objective-C as DataCache but referencing in swift as DataCacheManagedObject
@objc(DataCache)
public class DataCacheManagedObject: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, serializedUserPreferencesData: String? = nil, serializedPlannerData: String? = nil) {
        self.init(context: context)
    }
    
}
