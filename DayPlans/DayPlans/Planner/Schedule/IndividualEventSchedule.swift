//
//  IndividualEventSchedule.swift
//  DayPlans
//
//  Created by Will Brandon on 9/6/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit

class IndividualEventSchedule: Schedule {
    
    private var events_mutable: [Event]
    override var events: [Event] { events_mutable }
    
    override init(name: String? = nil) {
        events_mutable = []
        super.init(name: name)
    }
    
    // Override as a formality
    override func isActive(onDay day: DateTime) -> Bool { super.isActive(onDay: day) }
    
    func scheduleEvent(_ event: Event) {
        var insertionIndex = 0
        for existingEvent in events {
            if event.dateTime > existingEvent.dateTime {
                insertionIndex += 1
            }
        }
        events_mutable.insert(event, at: insertionIndex)
        event.associatedSchedule = self
        event.isScheduled_flag = self.isPlanned_flag
    }
    
    func cancelEvent(_ event: Event) {
        event.isScheduled_flag = false
        event.associatedSchedule = nil
        events_mutable.removeAll(where: { $0 == event })
    }
    
}
