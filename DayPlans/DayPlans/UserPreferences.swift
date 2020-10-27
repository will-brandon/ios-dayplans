//
//  UserPreferences.swift
//  DayPlans
//
//  Created by Will Brandon on 9/20/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class UserPreferences: IdentifiableObject {
    
    private static var current_mutable: UserPreferences = {
        if let userPreferences = DataCache.current.fetchUserPreferences() {
            return userPreferences
        }
        let newUserPreferences = UserPreferences()
        DataCache.current.trySave(userPreferences: newUserPreferences)
        return newUserPreferences
    }()
    class var current: UserPreferences { current_mutable }
    
    @discardableResult private class func trySaveCurrentToDataCache() -> Bool { DataCache.current.trySave(userPreferences: current) }
    
    var timeStyle: TimeStyle { didSet { saveToDataCacheIfCurrent() } }
    var timeStyleResultingLocale: Locale { (timeStyle == .civil) ? Locale(identifier: "en") : Locale(identifier: "en_GB") }
    
    init(timeStyle: TimeStyle = Properties.USER_PREFERENCES_DEFAULT_TIME_STYLE) {
        self.timeStyle = timeStyle
        super.init()
    }
    
    private func saveToDataCacheIfCurrent() {
        if self == UserPreferences.current {
            UserPreferences.trySaveCurrentToDataCache()
        }
    }
    
}
