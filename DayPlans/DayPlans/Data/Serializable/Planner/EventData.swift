//
//  EventData.swift
//  DayPlans
//
//  Created by Will Brandon on 10/2/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit

struct EventData: Codable {
    
    let date: Date
    let title: String
    let locationName: String?
    let description: String?
    let associatedColorData: AssociatedColorData
    
    let notificationWasQueued: Bool
    
    init(date: Date, title: String, locationName: String?, description: String?, associatedColorData: AssociatedColorData, notificationWasQueued: Bool, notificationID: UInt) {
        self.date = date
        self.title = title
        self.locationName = locationName
        self.description = description
        self.associatedColorData = associatedColorData
        self.notificationWasQueued = notificationWasQueued
    }
    
    init(fromEvent event: Event) {
        date = event.dateTime.date
        title = event.title
        locationName = event.locationName
        description = event.description
        associatedColorData = AssociatedColorData(fromAssociatedColor: event.associatedColor)
        notificationWasQueued = event.notification.wasQueued
    }
    
    func event() -> Event { Event(dateTime: DateTime(forDate: date), title: title, locationName: locationName, description: description, associatedColor: associatedColorData.associatedColor(), savedNotificationWasQueued: notificationWasQueued) }
    
}
