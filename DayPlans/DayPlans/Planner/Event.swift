//
//  Event.swift
//  DayPlans
//
//  Created by Will Brandon on 7/19/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit

class Event: IdentifiableObject, Removable {
    
    class Notification: IdentifiableObject {
        
        var idString: String { "event-notification-\(self.id)" }
        
        private var eventDateTime: DateTime
        private let eventTitle: String
        private let eventLocationName: String?
        
        private var wasQueued_mutable: Bool
        var wasQueued: Bool { wasQueued_mutable }
        
        var preferredTimeStyleDisplayString: String { (UserPreferences.current.timeStyle == .civil) ? eventDateTime.time.civilDisplayString : eventDateTime.time.displayString }
        
        fileprivate init(eventDateTime: DateTime, eventTitle: String, eventLocationName: String?, savedWasQueued: Bool) {
            self.eventDateTime = eventDateTime
            self.eventTitle = eventTitle
            self.eventLocationName = eventLocationName
            wasQueued_mutable = savedWasQueued
            super.init()
        }
        
        @discardableResult fileprivate func tryQueue() -> Bool {
            if !wasQueued {
                NotificationManager.current.queueNotification(atDateTime: eventDateTime, id: idString, title: Properties.NOTIFICATION_TITLE_STRING_PROVIDER(eventTitle, preferredTimeStyleDisplayString), body: Properties.NOTIFICATION_LOCATION_STRING_PROVIDER(eventLocationName), sound: Properties.NOTIFICATION_SOUND)
                wasQueued_mutable = true
                return true
            }
            return false
        }
        
        @discardableResult fileprivate func tryUnqueue() -> Bool {
            if wasQueued {
                wasQueued_mutable = false
                NotificationManager.current.unqueueNotification(withID: idString)
                return true
            }
            return false
        }
        
    }
    
    var shouldBeRemoved_flag: Bool
    
    let dateTime: DateTime
    let title: String
    let locationName: String?
    let description: String?
    let associatedColor: AssociatedColor
    
    let notification: Notification
    
    var associatedSchedule: Schedule?
    
    var isScheduled_flag: Bool {
        didSet {
            if isScheduled_flag {
                notification.tryQueue()
            } else {
                notification.tryUnqueue()
            }
        }
    }
    
    var preferredTimeStyleDisplayString: String { (UserPreferences.current.timeStyle == .civil) ? dateTime.time.civilDisplayString : dateTime.time.displayString }
    
    init(dateTime: DateTime, title: String, locationName: String? = nil, description: String? = nil, associatedColor: AssociatedColor? = nil, savedNotificationWasQueued: Bool = false) {
        shouldBeRemoved_flag = false
        self.dateTime = dateTime
        self.title = title
        self.locationName = locationName
        self.description = description
        if associatedColor != nil {
            self.associatedColor = associatedColor!
        } else {
            self.associatedColor = AssociatedColor.random()
        }
        notification = Notification(eventDateTime: dateTime, eventTitle: title, eventLocationName: locationName, savedWasQueued: savedNotificationWasQueued)
        associatedSchedule = nil
        isScheduled_flag = false
        super.init()
    }
    
}
