//
//  Schedule.swift
//  DayPlans
//
//  Created by Will Brandon on 7/20/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class Schedule: IdentifiableObject {
    
    let name: String?
    var events: [Event] { [] }
    
    var isPlanned_flag: Bool {
        didSet {
            for event in events {
                event.isScheduled_flag = isPlanned_flag
            }
        }
    }
    
    init(name: String? = nil) {
        self.name = name
        isPlanned_flag = false
        super.init()
    }
    
    func isActive(onDay day: DateTime) -> Bool { true }
    
    func scheduledEvents(forDay day: DateTime) -> [Event] {
        var scheduledEvents = [Event]()
        if isActive(onDay: day) {
            for event in events {
                if event.dateTime.isSameDay(as: day) {
                    scheduledEvents.append(event)
                }
            }
        }
        return scheduledEvents
    }
    
}
