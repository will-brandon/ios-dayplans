//
//  DayRotationScheduleEditorViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayRotationScheduleEditorViewController: UIViewController {
    
    var presetDayRotationSchedule: DayRotationSchedule?
    
    var pendingName: String?
    var pendingFirstDay: DateTime?
    var pendingLastDay: DateTime?
    var pendingActiveWeekdays: [Weekday]?
    var pendingBlocks: [Block]?
    var pendingDays: [DayRotationSchedule.Day]?
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        if let tabBarController = DayRotationScheduleEditorTabBarController.current {
            switch tabBarController.selectedIndex {
            case 0:
                tabBarController.nextTab()
                break
            case 1:
                tabBarController.nextTab()
                break
            case 2:
                if
                    let name = pendingName,
                    let firstDay = pendingFirstDay,
                    let lastDay = pendingLastDay,
                    let activeWeekdays = pendingActiveWeekdays,
                    let days = pendingDays
                {
                    let newDayRotationSchedule = DayRotationSchedule(name: name, days: days, firstDay: firstDay, lastDay: lastDay, activeWeekdays: activeWeekdays)
                    if let presetDayRotationSchedule = presetDayRotationSchedule {
                        Planner.current.remove(dayRotationSchedule: presetDayRotationSchedule)
                    }
                    Planner.current.add(dayRotationSchedule: newDayRotationSchedule)
                    ScheduleManagerTableViewController.current?.refresh()
                }
                self.dismiss(animated: true)
                break
            default:
                self.dismiss(animated: true)
                break
            }
        }
    }
    
}

extension DayRotationScheduleEditorViewController {
    
    private static var current_mutable: DayRotationScheduleEditorViewController?
    class var current: DayRotationScheduleEditorViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayRotationScheduleEditorViewController.current_mutable = self
        super.viewDidLoad()
        pendingBlocks = presetDayRotationSchedule?.blocks ?? []
        pendingDays = presetDayRotationSchedule?.days ?? []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayRotationScheduleEditorViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayRotationScheduleEditorViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
