//
//  Console.swift
//  DayPlans
//
//  Created by Will Brandon on 9/1/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class Console {
    
    static func log(_ message: String = "") {
        print(Properties.CONSOLE_LOG_PREFIX + message)
    }
    
    static func log(lines: [String]) {
        var isFirstLine = true
        for line in lines {
            if isFirstLine {
                print(Properties.CONSOLE_LOG_PREFIX + line)
                isFirstLine = false
            } else {
                print(Properties.CONSOLE_LOG_EXTRA_LINE_PREFIX + line)
            }
        }
    }
    
    static func error(_ message: String = "") {
        print(Properties.CONSOLE_ERROR_PREFIX + message)
    }
    
    static func error(_ error: Error) {
        Console.error(error.localizedDescription)
    }
    
    static func error(lines: [String]) {
        var isFirstLine = true
        for line in lines {
            if isFirstLine {
                print(Properties.CONSOLE_ERROR_PREFIX + line)
                isFirstLine = false
            } else {
                print(Properties.CONSOLE_ERROR_EXTRA_LINE_PREFIX + line)
            }
        }
    }
    
}
