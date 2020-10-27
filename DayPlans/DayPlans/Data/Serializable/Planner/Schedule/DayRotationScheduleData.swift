//
//  DayRotationScheduleData.swift
//  DayPlans
//
//  Created by Will Brandon on 10/2/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

struct DayRotationScheduleData: Codable {
    
    struct DayData: Codable {
        
        let name: String
        let blockTimeInstanceDatas: [BlockData.TimeInstanceData]
        
        init(name: String, blockTimeInstanceDatas: [BlockData.TimeInstanceData]) {
            self.name = name
            self.blockTimeInstanceDatas = blockTimeInstanceDatas
        }
        
        init(fromDay day: DayRotationSchedule.Day) {
            name = day.name
            var blockTimeInstanceDatas = [BlockData.TimeInstanceData]()
            for blockTimeInstance in day.blockTimeInstances {
                blockTimeInstanceDatas.append(BlockData.TimeInstanceData(fromTimeInstance: blockTimeInstance))
            }
            self.blockTimeInstanceDatas = blockTimeInstanceDatas
        }
        
        func day() -> DayRotationSchedule.Day {
            var blockTimeInstances = [Block.TimeInstance]()
            for blockTimeInstanceData in blockTimeInstanceDatas {
                blockTimeInstances.append(blockTimeInstanceData.timeInstance())
            }
            return DayRotationSchedule.Day(name: name, blockTimeInstances: blockTimeInstances)
        }
        
    }
    
    let name: String?
    let dayDatas: [DayData]
    let firstDayDate, lastDayDate: Date
    let activeWeekdays: [Weekday]
    
    let savedEventDatas: [EventData]
    // Remember to deal with notifications!!!! Things get really tricky here
    
    init(name: String?, dayDatas: [DayData], firstDayDate: Date, lastDayDate: Date, activeWeekdays: [Weekday], savedEventDatas: [EventData]) {
        self.name = name
        self.dayDatas = dayDatas
        self.firstDayDate = firstDayDate
        self.lastDayDate = lastDayDate
        self.activeWeekdays = activeWeekdays
        self.savedEventDatas = savedEventDatas
    }
    
    init(fromDayRotationSchedule dayRotationSchedule: DayRotationSchedule) {
        name = dayRotationSchedule.name
        var dayDatas = [DayData]()
        for day in dayRotationSchedule.days {
            dayDatas.append(DayData(fromDay: day))
        }
        self.dayDatas = dayDatas
        firstDayDate = dayRotationSchedule.firstDay.date
        lastDayDate = dayRotationSchedule.firstDay.date
        activeWeekdays = dayRotationSchedule.activeWeekdays
        var savedEventDatas = [EventData]()
        for event in dayRotationSchedule.events {
            savedEventDatas.append(EventData(fromEvent: event))
        }
        self.savedEventDatas = savedEventDatas
    }
    
    func dayRotationSchedule() -> DayRotationSchedule {
        var days = [DayRotationSchedule.Day]()
        for dayData in dayDatas {
            days.append(dayData.day())
        }
        var savedEvents = [Event]()
        for savedEventData in savedEventDatas {
            savedEvents.append(savedEventData.event())
        }
        return DayRotationSchedule(name: name, days: days, firstDay: DateTime(forDate: firstDayDate), lastDay: DateTime(forDate: lastDayDate), activeWeekdays: activeWeekdays, savedEvents: savedEvents)
    }
    
}
