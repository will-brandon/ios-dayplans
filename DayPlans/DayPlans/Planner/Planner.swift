//
//  Planner.swift
//  DayPlans
//
//  Created by Will Brandon on 7/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class Planner: IdentifiableObject {
    
    private static var current_mutable: Planner = {
        let planner = DataCache.current.fetchPlanner()
        if let planner = DataCache.current.fetchPlanner() {
            return planner
        }
        let newPlanner = Planner()
        DataCache.current.trySave(planner: newPlanner)
        return newPlanner
    }()
    class var current: Planner { current_mutable }
    
    @discardableResult private class func trySaveCurrentToDataCache() -> Bool { DataCache.current.trySave(planner: current) }
    
    let individualEventSchedule: IndividualEventSchedule
    
    private var dayRotationSchedules_mutable: [DayRotationSchedule]
    var dayRotationSchedules: [DayRotationSchedule] { dayRotationSchedules_mutable }
    
    var events: [Event] {
        var events = individualEventSchedule.events
        for dayRotationSchedule in dayRotationSchedules {
            events.append(contentsOf: dayRotationSchedule.events)
        }
        events.sort { $1.dateTime > $0.dateTime }
        return events
    }
    
    var eventsGroupedByDayDate: [Date:[Event]] { Dictionary(grouping: events) { $0.dateTime.startOfThisDay.date } }
    
    init(savedIndividualEventSchedule: IndividualEventSchedule = IndividualEventSchedule(), savedDayRotationSchedules: [DayRotationSchedule] = []) {
        individualEventSchedule = savedIndividualEventSchedule
        dayRotationSchedules_mutable = savedDayRotationSchedules
        individualEventSchedule.isPlanned_flag = true
        for dayRotationSchedule in savedDayRotationSchedules {
            dayRotationSchedule.isPlanned_flag = true
        }
        super.init()
    }
    
    private func saveToDataCacheIfCurrent() {
        if self == Planner.current {
            _ = Planner.trySaveCurrentToDataCache()
        }
    }
    
    func add(event: Event) {
        individualEventSchedule.scheduleEvent(event)
        saveToDataCacheIfCurrent()
    }
    func remove(event: Event) {
        individualEventSchedule.cancelEvent(event)
        saveToDataCacheIfCurrent()
    }
    func clearEvents() {
        for event in individualEventSchedule.events {
            remove(event: event)
        }
    }
    
    func add(dayRotationSchedule: DayRotationSchedule) {
        dayRotationSchedules_mutable.append(dayRotationSchedule)
        dayRotationSchedule.isPlanned_flag = true
        saveToDataCacheIfCurrent()
    }
    func remove(dayRotationSchedule: DayRotationSchedule) {
        dayRotationSchedule.isPlanned_flag = false
        dayRotationSchedules_mutable.removeAll(where: { $0 == dayRotationSchedule })
        saveToDataCacheIfCurrent()
    }
    func clearDayRotationSchedules() {
        dayRotationSchedules_mutable = []
    }
    
    func clear() {
        clearEvents()
        clearDayRotationSchedules()
    }
    
    func events(forDay day: DateTime) -> [Event] {
        var events = individualEventSchedule.scheduledEvents(forDay: day)
        for dayRotationSchedule in dayRotationSchedules {
            events.append(contentsOf: dayRotationSchedule.scheduledEvents(forDay: day))
        }
        return events
    }
    
}
