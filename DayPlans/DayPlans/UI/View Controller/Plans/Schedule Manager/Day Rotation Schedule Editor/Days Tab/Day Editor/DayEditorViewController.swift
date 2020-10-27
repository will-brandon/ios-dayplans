//
//  DayEditorViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayEditorViewController: UIViewController {
    
    var presetDay: DayRotationSchedule.Day?
    
    var pendingBlockTimeInstances: [Block.TimeInstance]?
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        if let tableViewController = DayEditorTableViewController.current {
            let name = ((tableViewController.nameTextField.text != nil) && (tableViewController.nameTextField.text != "")) ? tableViewController.nameTextField.text! : "Untitled Day"
            if let presetDay = presetDay {
                if let replacementIndex = DayRotationScheduleEditorViewController.current?.pendingDays?.firstIndex(where: { $0.probablyEquals(presetDay) }), let blockTimeInstances = pendingBlockTimeInstances {
                    DayRotationScheduleEditorViewController.current?.pendingDays?[replacementIndex] = DayRotationSchedule.Day(name: name, blockTimeInstances: blockTimeInstances)
                }
            } else if let blockTimeInstances = pendingBlockTimeInstances {
                DayRotationScheduleEditorViewController.current?.pendingDays?.append(DayRotationSchedule.Day(name: name, blockTimeInstances: blockTimeInstances))
            }
            DayRotationScheduleEditorDaysTabTableViewController.current?.refresh()
            self.dismiss(animated: true)
        }
    }
    
}

extension DayEditorViewController {
    
    private static var current_mutable: DayEditorViewController?
    class var current: DayEditorViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayEditorViewController.current_mutable = self
        super.viewDidLoad()
        pendingBlockTimeInstances = presetDay?.blockTimeInstances ?? []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayEditorViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayEditorViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
