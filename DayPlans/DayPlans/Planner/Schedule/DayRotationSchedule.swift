//
//  DayRotationSchedule.swift
//  DayPlans
//
//  Created by Will Brandon on 7/19/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit

class DayRotationSchedule: Schedule {
    
    struct Day {
        
        let name: String
        var blockTimeInstances: [Block.TimeInstance]
        
        func probablyEquals(_ otherDay: Day) -> Bool { (name == otherDay.name) && (blockTimeInstances.count == otherDay.blockTimeInstances.count) }
        
    }
    
    let days: [Day]
    
    let firstDay, lastDay: DateTime
    let activeWeekdays: [Weekday]
    
    private lazy var inactiveWeekdays_mutable: [Weekday] = {
        var inactiveWeekdays = [Weekday]()
        for weekdayRawValue in 1...7 {
            let weekday = Weekday(rawValue: weekdayRawValue)!
            if !self.activeWeekdays.contains(weekday) {
                inactiveWeekdays.append(weekday)
            }
        }
        return inactiveWeekdays
    }()
    var inactiveWeekdays: [Weekday] { inactiveWeekdays_mutable }
    
    private var events_mutable: [Event]
    override var events: [Event] { events_mutable }
    
    private lazy var blocks_mutable: [Block] = {
        var blocks = [Block]()
        days.forEach {
            $0.blockTimeInstances.forEach {
                (blockTimeInstance) in
                if !blocks.contains(where: { $0.title == blockTimeInstance.block.title }) {
                    blocks.append(blockTimeInstance.block)
                }
            }
        }
        return blocks
    }()
    var blocks: [Block] { blocks_mutable }
    
    init(name: String? = nil, days: [Day], firstDay: DateTime, lastDay: DateTime, activeWeekdays: [Weekday], savedEvents: [Event] = []) {
        self.days = days
        self.firstDay = firstDay.startOfThisDay
        self.lastDay = lastDay.startOfThisDay
        self.activeWeekdays = activeWeekdays
        events_mutable = savedEvents
        super.init(name: name)
        if savedEvents.isEmpty {
            createAllEvents()
        }
        for event in savedEvents {
            event.associatedSchedule = self
        }
    }
    
    override func isActive(onDay day: DateTime) -> Bool { day.days(since: firstDay) >= 0 && day.days(until: lastDay) >= 0 && activeWeekdays.contains(day.weekday) && (days.count > 0) }
    
    private func createEvents(forDay day: DateTime) {
        if isActive(onDay: day) {
            for blockTimeInstance in days[dayRotationIteration(forDay: day)].blockTimeInstances {
                let eventDateTime = day.dateTimeOfThisDay(atTime: blockTimeInstance.time)
                let event = blockTimeInstance.block.event(atDateTime: eventDateTime)
                event.associatedSchedule = self
                event.isScheduled_flag = self.isPlanned_flag
                events_mutable.append(event)
            }
        }
    }
    
    private func createAllEvents() {
        for dayIteration in 0...firstDay.days(until: lastDay) {
            createEvents(forDay: firstDay.dateTimeAfter(days: dayIteration))
        }
    }
    
    func dayIteration(forDay day: DateTime) -> Int {
        if isActive(onDay: day) {
            return day.days(since: firstDay) + dayIterationDeviation(forDay: day)
        }
        return -1
    }
    
    func dayIterationDeviation(forDay day: DateTime) -> Int {
        var dayIterationDeviation = 0
        for inactiveWeekday in inactiveWeekdays {
            dayIterationDeviation -= day.occurrences(ofWeekday: inactiveWeekday, since: firstDay)
        }
        return dayIterationDeviation
    }
    
    func dayRotationIteration(forDay day: DateTime) -> Int { dayIteration(forDay: day) % days.count }
    
}
