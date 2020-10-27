//
//  DayRotationScheduleEditorGeneralTabTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayRotationScheduleEditorGeneralTabTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var sundayIsActiveWeekdaySwitch: UISwitch!
    @IBOutlet weak var mondayIsActiveWeekdaySwitch: UISwitch!
    @IBOutlet weak var tuesdayIsActiveWeekdaySwitch: UISwitch!
    @IBOutlet weak var wednesdayIsActiveWeekdaySwitch: UISwitch!
    @IBOutlet weak var thursdayIsActiveWeekdaySwitch: UISwitch!
    @IBOutlet weak var fridayIsActiveWeekdaySwitch: UISwitch!
    @IBOutlet weak var saturdayIsActiveWeekdaySwitch: UISwitch!
    
    @discardableResult func tryLoadPresetDayRotationSchedule() -> Bool {
        if let presetDayRotationSchedule = DayRotationScheduleEditorViewController.current?.presetDayRotationSchedule {
            nameTextField.text = presetDayRotationSchedule.name
            startDatePicker.date = presetDayRotationSchedule.firstDay.date
            endDatePicker.date = presetDayRotationSchedule.lastDay.date
            sundayIsActiveWeekdaySwitch.isOn = presetDayRotationSchedule.activeWeekdays.contains(.sunday)
            mondayIsActiveWeekdaySwitch.isOn = presetDayRotationSchedule.activeWeekdays.contains(.monday)
            tuesdayIsActiveWeekdaySwitch.isOn = presetDayRotationSchedule.activeWeekdays.contains(.tuesday)
            wednesdayIsActiveWeekdaySwitch.isOn = presetDayRotationSchedule.activeWeekdays.contains(.wednesday)
            thursdayIsActiveWeekdaySwitch.isOn = presetDayRotationSchedule.activeWeekdays.contains(.thursday)
            fridayIsActiveWeekdaySwitch.isOn = presetDayRotationSchedule.activeWeekdays.contains(.friday)
            saturdayIsActiveWeekdaySwitch.isOn = presetDayRotationSchedule.activeWeekdays.contains(.saturday)
            return true
        }
        return false
    }
    
    func contributeInputs() {
        let name = ((nameTextField.text != nil) && (nameTextField.text != "")) ? nameTextField.text! : "Untitled Schedule"
        let firstDay = DateTime(forDate: startDatePicker.date).startOfThisDay
        let lastDay = DateTime(forDate: endDatePicker.date).startOfThisDay
        var activeWeekdays = [Weekday]()
        if sundayIsActiveWeekdaySwitch.isOn { activeWeekdays.append(.sunday) }
        if mondayIsActiveWeekdaySwitch.isOn { activeWeekdays.append(.monday) }
        if tuesdayIsActiveWeekdaySwitch.isOn { activeWeekdays.append(.tuesday) }
        if wednesdayIsActiveWeekdaySwitch.isOn { activeWeekdays.append(.wednesday) }
        if thursdayIsActiveWeekdaySwitch.isOn { activeWeekdays.append(.thursday) }
        if fridayIsActiveWeekdaySwitch.isOn { activeWeekdays.append(.friday) }
        if saturdayIsActiveWeekdaySwitch.isOn { activeWeekdays.append(.saturday) }
        if firstDay <= lastDay {
            DayRotationScheduleEditorViewController.current?.pendingName = name
            DayRotationScheduleEditorViewController.current?.pendingFirstDay = firstDay
            DayRotationScheduleEditorViewController.current?.pendingLastDay = lastDay
            DayRotationScheduleEditorViewController.current?.pendingActiveWeekdays = activeWeekdays
        }
    }

}

extension DayRotationScheduleEditorGeneralTabTableViewController {
    
    private static var current_mutable: DayRotationScheduleEditorGeneralTabTableViewController?
    class var current: DayRotationScheduleEditorGeneralTabTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayRotationScheduleEditorGeneralTabTableViewController.current_mutable = self
        super.viewDidLoad()
        // Not needed because these date pickers don't have time components
        //startDatePicker.locale = UserPreferences.current.timeStyleResultingLocale
        //endDatePicker.locale = UserPreferences.current.timeStyleResultingLocale
        tryLoadPresetDayRotationSchedule()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayRotationScheduleEditorGeneralTabTableViewController.current_mutable = self
        super.viewDidAppear(animated)
        tryLoadPresetDayRotationSchedule()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayRotationScheduleEditorGeneralTabTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
