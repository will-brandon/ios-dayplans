//
//  UserPreferencesData.swift
//  DayPlans
//
//  Created by Will Brandon on 10/7/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class UserPreferencesData: Codable {
    
    let timeStyle: TimeStyle
    
    init(timeStyle: TimeStyle) {
        self.timeStyle = timeStyle
    }
    
    init(fromUserPreferences userPreferences: UserPreferences) {
        timeStyle = userPreferences.timeStyle
    }
    
    func userPreferences() -> UserPreferences { UserPreferences(timeStyle: timeStyle) }
    
}
