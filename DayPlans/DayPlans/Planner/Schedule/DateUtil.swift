//
//  DateUtil.swift
//  DayPlans
//
//  Created by Will Brandon on 7/20/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class DateUtil {
    
    static func monthName(from month: Int) -> String {
        switch month {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return "INVALID MONTH"
        }
    }
    
    static func weekdayName(from weekday: Int) -> String {
        switch weekday {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "INVALID WEEKDAY"
        }
    }
    
}
