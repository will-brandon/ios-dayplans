//
//  IndividualEventScheduleData.swift
//  DayPlans
//
//  Created by Will Brandon on 10/2/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

struct IndividualEventScheduleData: Codable {
    
    let name: String?
    let eventDatas: [EventData]
    
    init(name: String?, eventDatas: [EventData]) {
        self.name = name
        self.eventDatas = eventDatas
    }
    
    init(fromIndividualEventSchedule individualEventSchedule: IndividualEventSchedule) {
        name = individualEventSchedule.name
        var eventDatas = [EventData]()
        for event in individualEventSchedule.events {
            eventDatas.append(EventData(fromEvent: event))
        }
        self.eventDatas = eventDatas
    }
    
    func individualEventSchedule() -> IndividualEventSchedule {
        let individualEventSchedule = IndividualEventSchedule(name: name)
        for eventData in eventDatas {
            individualEventSchedule.scheduleEvent(eventData.event())
        }
        return individualEventSchedule
    }
    
}
