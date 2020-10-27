//
//  Tester.swift
//  DayPlans
//
//  Created by Will Brandon on 7/19/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Tester {
    
    class func executeTests() {
        Console.log("Executing tests")
        main()
    }
    
    private class func main() {
        testDataCache()
    }
    
    private class func produceSchoolSchedule() -> DayRotationSchedule {
        let now = DateTime.now
        
        let block1Time = now.dateTimeAfter(seconds: 5).time
        let block2Time = now.dateTimeAfter(seconds: 10).time
        let block3Time = now.dateTimeAfter(seconds: 15).time
        let block4Time = now.dateTimeAfter(seconds: 20).time
        
        let chemistryCourse = Block(title: "Chemistry", locationName: "MHS RM#103", description: nil, associatedColor: AssociatedColor.green)
        let calculusCourse = Block(title: "Calculus", locationName: "MHS RM#215", description: "test", associatedColor: AssociatedColor.blue)
        let statisticsCourse = Block(title: "Statistics", locationName: "MHS RM#215", description: nil, associatedColor: AssociatedColor.red)
        let usHistoryCourse = Block(title: "US History", locationName: "MHS RM#201", description: nil, associatedColor: AssociatedColor.brown)
        
        let schoolDay1 = DayRotationSchedule.Day(name: "Day 1", blockTimeInstances: [chemistryCourse.timeInstance(forTime: block1Time), calculusCourse.timeInstance(forTime: block2Time), statisticsCourse.timeInstance(forTime: block3Time), usHistoryCourse.timeInstance(forTime: block4Time)])
        let schoolDay2 = DayRotationSchedule.Day(name: "Day 2", blockTimeInstances: [statisticsCourse.timeInstance(forTime: block1Time), calculusCourse.timeInstance(forTime: block3Time), usHistoryCourse.timeInstance(forTime: block4Time)])
        let schoolDay3 = DayRotationSchedule.Day(name: "Day 3", blockTimeInstances: [chemistryCourse.timeInstance(forTime: block2Time), statisticsCourse.timeInstance(forTime: block3Time), calculusCourse.timeInstance(forTime: block4Time)])
        
        let schoolSchedule = DayRotationSchedule(
            name: "Melrose High School",
            days: [schoolDay1, schoolDay2, schoolDay3],
            firstDay: now,
            lastDay: now.dateTimeAfter(days: 7),
            activeWeekdays: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        )
        return schoolSchedule
    }
    
    private class func testDateTime() {
        let now = DateTime.now
        
        for i in 0...48 {
            let time = now.dateTimeAfter(hours: i).time
            print(time.civilDisplayString)
        }
    }
    
    private class func testSchoolSchedule() {
        let schoolSchedule = produceSchoolSchedule()
        let now = DateTime.now
        
        for dayIndex in 0...schoolSchedule.firstDay.days(until: schoolSchedule.lastDay) {
            let day = now.dateTimeAfter(days: dayIndex)
            let events = schoolSchedule.scheduledEvents(forDay: day)
            var string = "Day \(dayIndex)"
            for event in events {
                string.append("\t| \(event.title)")
            }
            print(string)
        }
    }
    
    private class func testNotifications() {
        let triggerDateTime = DateTime.now.dateTimeAfter(seconds: 5)
        NotificationManager.current.queueNotification(atDateTime: triggerDateTime, id: "a", title: "Test 2")
    }
    
    private class func testPlanner() {
        let schoolSchedule = produceSchoolSchedule()
        let now = DateTime.now
        
        Planner.current.add(dayRotationSchedule: schoolSchedule)
        let event1 = Event(dateTime: now.dateTimeAfter(seconds: 7), title: "Event 1", locationName: "Melrose High School")
        let event2 = Event(dateTime: now.dateTimeAfter(seconds: 17), title: "Event 2")
        let event3 = Event(dateTime: now.dateTimeAfter(seconds: 30), title: "Event 3")
        Planner.current.add(event: event2)
        Planner.current.add(event: event1)
        Planner.current.add(event: event3)
    }
    
    private class func testCoreData() {
        UserPreferences.current.timeStyle = .military
        print(UserPreferences.current.timeStyle)
    }
    
    private class func testSerializable() {
        let now = DateTime.now
        
        let event = Event(dateTime: now.dateTimeAfter(days: 1), title: "Some Event", locationName: "Melrose High School", description: "Idk locker assignment or something", associatedColor: AssociatedColor.red)
        Planner.current.add(event: event)
        let serializedSchoolSchedule = Serializer.current.serialize(encodable: EventData(fromEvent: event))
        let recreatedEvent = Serializer.current.deserialize(decodableType: EventData.self, serializedObject: serializedSchoolSchedule!)?.event()
        dump(recreatedEvent)
    }
    
    private class func testDataCache() {
        let now = DateTime.now
        let event = Event(dateTime: now.dateTimeAfter(days: 1), title: "Some Event", locationName: "Melrose High School", description: "Idk locker assignment or something", associatedColor: AssociatedColor.magenta)
        Planner.current.add(event: event)
        Planner.current.add(dayRotationSchedule: produceSchoolSchedule())
    }
    
}
