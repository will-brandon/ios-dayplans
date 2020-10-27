//
//  Time.swift
//  DayPlans
//
//  Created by Will Brandon on 9/1/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

struct Time: Codable {
    
    let hour: Int
    var civilHour: Int { (hour == 0) ? 12 : ((isPM && (hour > 12)) ? (hour - 12) : hour) }
    let minute: Int
    let second: Int
    let nanosecond: Int
    
    var isPM: Bool { hour >= 12 }
    
    var amPMString: String { isPM ? "PM" : "AM" }
    var doubleDigitMinuteString: String { (String(minute).count > 1) ? "\(minute)" : "0\(minute)" }
    var displayString: String { "\(hour):\(doubleDigitMinuteString)" }
    var civilDisplayString: String { "\(civilHour):\(doubleDigitMinuteString) \(amPMString)" }
    
}
