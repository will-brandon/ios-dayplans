//
//  DateUtil.swift
//  DayPlans
//
//  Created by Will Brandon on 7/21/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class DateUtil {
    
    static let MILLISECONDS_IN_SECOND = 1_000
    static let SECONDS_IN_MINUTE = 60
    static let MINUTES_IN_HOUR = 60
    static let HOURS_IN_DAY = 24
    static let DAYS_IN_WEEK = 7
    
    static let SECONDS_IN_HOUR = MINUTES_IN_HOUR * SECONDS_IN_MINUTE
    static let SECONDS_IN_DAY = HOURS_IN_DAY * SECONDS_IN_HOUR
    static let SECONDS_IN_WEEK = DAYS_IN_WEEK * SECONDS_IN_DAY
    
    class func dateComponents(era: Int, year: Int, month: Month, day: Int, hour: Int, minute: Int, second: Int, nanosecond: Int) -> DateComponents? {
        return DateComponents(
            calendar: nil,
            timeZone: nil,
            era: era,
            year: year,
            month: month.rawValue,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond,
            weekday: nil,
            weekdayOrdinal: nil,
            quarter: nil,
            weekOfMonth: nil,
            weekOfYear: nil,
            yearForWeekOfYear: nil
        )
    }
    
    class func dateComponents(fromDateTime dateTime: DateTime) -> DateComponents? {
        return dateComponents(
            era: dateTime.era,
            year: dateTime.year,
            month: dateTime.month,
            day: dateTime.day,
            hour: dateTime.hour,
            minute: dateTime.minute,
            second: dateTime.second,
            nanosecond: dateTime.nanosecond
        )
    }
    
    class func date(era: Int, year: Int, month: Month, day: Int, hour: Int, minute: Int, second: Int, nanosecond: Int) -> Date? {
        if let dateComponents = DateUtil.dateComponents(era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond) {
            return Calendar.current.date(from: dateComponents)
        }
        return nil
    }
    
    class func date(era: Int, year: Int, month: Month, day: Int, time: Time) -> Date? { date(era: era, year: year, month: month, day: day, hour: time.hour, minute: time.minute, second: time.second, nanosecond: time.nanosecond) }
    
}
