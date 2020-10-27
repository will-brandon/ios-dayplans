//
//  DataCache+CoreDataProperties.swift
//  DayPlans
//
//  Created by Will Brandon on 10/7/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//
//

import Foundation
import CoreData


extension DataCacheManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataCacheManagedObject> {
        return NSFetchRequest<DataCacheManagedObject>(entityName: "DataCache")
    }

    @NSManaged public var serializedUserPreferencesData: String?
    @NSManaged public var serializedPlannerData: String?

}
