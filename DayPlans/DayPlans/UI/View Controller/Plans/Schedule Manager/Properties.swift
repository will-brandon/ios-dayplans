//
//  Properties.swift
//  DayPlans
//
//  Created by Will Brandon on 9/1/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

enum Properties {
    
    // MARK: - Debugging
    static let SHOULD_CLEAR_DATA_CACHE_AT_LAUNCH = false
    static let SHOULD_EXECUTE_TESTS = false
    
    // MARK: - Console
    static let CONSOLE_LOG_PREFIX = "DayPlans >>  "
    static let CONSOLE_LOG_EXTRA_LINE_PREFIX = "         >>  "
    static let CONSOLE_ERROR_PREFIX = "DayPlans - ERROR >> "
    static let CONSOLE_ERROR_EXTRA_LINE_PREFIX = "                 >> "
    
    // MARK: - Notification
    static let NOTIFICATION_AUTHORIZATION_OPTIONS: UNAuthorizationOptions = [.alert, .badge, .sound]
    static let NOTIFICATION_SOUND = UNNotificationSound.default
    static let NOTIFICATION_TITLE_STRING_PROVIDER: (String, String) -> String = { "\($0) (\($1))" }
    static let NOTIFICATION_LOCATION_STRING_PROVIDER: (String?) -> String? = { ($0 != nil) ? "Location: \($0!)" : nil }
    
    // MARK: - User Preferences
    static let USER_PREFERENCES_DEFAULT_TIME_STYLE: TimeStyle = .civil
    
    // MARK: - User Interface
    static let UI_PLANS_TABLE_INDIVIDUAL_EVENT_ICON_IMAGE = UIImage(systemName: "square.and.pencil")!
    static let UI_PLANS_TABLE_SCHEDULE_EVENT_ICON_IMAGE = UIImage(systemName: "calendar")!
    
}
