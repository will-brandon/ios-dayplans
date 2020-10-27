//
//  PlannerData.swift
//  DayPlans
//
//  Created by Will Brandon on 10/7/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class PlannerData: Codable {
    
    let individualEventScheduleData: IndividualEventScheduleData
    let dayRotationScheduleDatas: [DayRotationScheduleData]
    
    init(id: UInt, individualEventScheduleData: IndividualEventScheduleData, dayRotationScheduleDatas: [DayRotationScheduleData]) {
        self.individualEventScheduleData = individualEventScheduleData
        self.dayRotationScheduleDatas = dayRotationScheduleDatas
    }
    
    init(fromPlanner planner: Planner) {
        individualEventScheduleData = IndividualEventScheduleData(fromIndividualEventSchedule: planner.individualEventSchedule)
        var dayRotationScheduleDatas = [DayRotationScheduleData]()
        for dayRotationSchedule in planner.dayRotationSchedules {
            dayRotationScheduleDatas.append(DayRotationScheduleData(fromDayRotationSchedule: dayRotationSchedule))
        }
        self.dayRotationScheduleDatas = dayRotationScheduleDatas
    }
    
    func planner() -> Planner {
        var dayRotationSchedules = [DayRotationSchedule]()
        for dayRotationScheduleData in dayRotationScheduleDatas {
            dayRotationSchedules.append(dayRotationScheduleData.dayRotationSchedule())
        }
        return Planner(savedIndividualEventSchedule: individualEventScheduleData.individualEventSchedule(), savedDayRotationSchedules: dayRotationSchedules)
    }
    
}
