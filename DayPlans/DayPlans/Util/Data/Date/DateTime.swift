//
//  DateTime.swift
//  DayPlans
//
//  Created by Will Brandon on 7/19/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

struct DateTime: Comparable {
    
    static var now: DateTime { DateTime(forDate: Date()) }
    
    static func < (dateTime1: DateTime, dateTime2: DateTime) -> Bool { dateTime1.timeInterval(since: dateTime2) < 0 }
    static func == (dateTime1: DateTime, dateTime2: DateTime) -> Bool { dateTime1.timeInterval(since: dateTime2) == 0 }
    static func > (dateTime1: DateTime, dateTime2: DateTime) -> Bool { dateTime1.timeInterval(since: dateTime2) > 0 }
    
    private var dateMutable: Date
    var date: Date { dateMutable }
    
    var era: Int { calendarComponent(.era) }
    var year: Int { calendarComponent(.year) }
    var month: Month { Month(rawValue: calendarComponent(.month))! }
    var day: Int { calendarComponent(.day) }
    var hour: Int { calendarComponent(.hour) }
    var minute: Int { calendarComponent(.minute) }
    var second: Int { calendarComponent(.second) }
    var nanosecond: Int { calendarComponent(.nanosecond) }
    var weekday: Weekday { Weekday(rawValue: calendarComponent(.weekday))! }
    
    var time: Time { Time(hour: hour, minute: minute, second: second, nanosecond: nanosecond) }
    
    var startOfThisDay: DateTime { DateTime(era: era, year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0)! }
    var startOfThisMinute: DateTime { DateTime(era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: 0, nanosecond: 0)! }
    
    var isToday: Bool { isSameDay(as: DateTime.now) }
    var hasPassed: Bool { self < DateTime.now }
    
    var dayDisplayString: String { "\(month.name) \(day), \(year)" }
    var dayLongDisplayString: String { "\(weekday.name), \(dayDisplayString)" }
    var dayAbbreviatedDisplayString: String { "\(month.abbreviatedName) \(day), \(year)" }
    
    init(forDate date: Date) {
        self.dateMutable = date
    }
    
    init?(era: Int, year: Int, month: Month, day: Int, hour: Int, minute: Int, second: Int, nanosecond: Int) {
        if let date = DateUtil.date(era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond) {
            self.init(forDate: date)
        }
        else {
            return nil
        }
    }
    
    init?(era: Int, year: Int, month: Month, day: Int, time: Time) {
        if let date = DateUtil.date(era: era, year: year, month: month, day: day, time: time) {
            self.init(forDate: date)
        }
        else {
            return nil
        }
    }
    
    private func calendarComponent(_ component: Calendar.Component) -> Int { Calendar.current.component(component, from: date) }
    
    private func dateTime(byAdding value: Int, toComponent component: Calendar.Component) -> DateTime { DateTime(forDate: Calendar.current.date(byAdding: component, value: value, to: date)!) }
    
    func dateTimeAfter(eras: Int) -> DateTime { dateTime(byAdding: eras, toComponent: .era) }
    func dateTimeAfter(years: Int) -> DateTime { dateTime(byAdding: years, toComponent: .year) }
    func dateTimeAfter(months: Int) -> DateTime { dateTime(byAdding: months, toComponent: .month) }
    func dateTimeAfter(weeks: Int) -> DateTime { dateTime(byAdding: DateUtil.DAYS_IN_WEEK * weeks, toComponent: .day) }
    func dateTimeAfter(days: Int) -> DateTime { dateTime(byAdding: days, toComponent: .day) }
    func dateTimeAfter(hours: Int) -> DateTime { dateTime(byAdding: hours, toComponent: .hour) }
    func dateTimeAfter(minutes: Int) -> DateTime { dateTime(byAdding: minutes, toComponent: .minute) }
    func dateTimeAfter(seconds: Int) -> DateTime { dateTime(byAdding: seconds, toComponent: .second) }
    func dateTimeAfter(nanoseconds: Int) -> DateTime { dateTime(byAdding: nanoseconds, toComponent: .nanosecond) }
    
    func dateTimeOfNext(weekday: Weekday, canBeThisDay: Bool = false) -> DateTime { dateTimeAfter(days: days(untilNextWeekday: weekday, canBeThisDay: canBeThisDay)).startOfThisDay }
    
    func dateTimeOfThisDay(atTime time: Time) -> DateTime { DateTime(era: era, year: year, month: month, day: day, time: time)! }
    
    func timeInterval(since other: DateTime) -> TimeInterval { date.timeIntervalSince(other.date) }
    func timeInterval(until other: DateTime) -> TimeInterval { -timeInterval(since: other) }
    
    func days(since other: DateTime) -> Int { Int(floor(startOfThisDay.timeInterval(since: other.startOfThisDay) / TimeInterval(DateUtil.SECONDS_IN_DAY))) }
    func days(until other: DateTime) -> Int { Int(floor(startOfThisDay.timeInterval(until: other.startOfThisDay) / TimeInterval(DateUtil.SECONDS_IN_DAY))) }
    func days(untilNextWeekday weekday: Weekday, canBeThisDay: Bool = false) -> Int {
        var days = weekday.rawValue - self.weekday.rawValue
        if (days < 0) || (!canBeThisDay && (days == 0)) {
            days += 7
        }
        return days
    }
    
    func occurrences(ofWeekday targetWeekday: Weekday, since other: DateTime) -> Int {
        var occurrences = days(since: other) / DateUtil.DAYS_IN_WEEK
        let remaindingDays = days(since: other) % DateUtil.DAYS_IN_WEEK
        let daysToNextTargetWeekday = other.dateTimeAfter(weeks: occurrences).days(untilNextWeekday: targetWeekday, canBeThisDay: true)
        if(daysToNextTargetWeekday <= remaindingDays) {
            occurrences += 1
        }
        return occurrences
    }
    
    func isSameDay(as other: DateTime) -> Bool { days(since: other) == 0 }
    
}
