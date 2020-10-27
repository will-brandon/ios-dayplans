//
//  ScheduleManagerViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/16/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class ScheduleManagerViewController: UIViewController {
    
    @IBAction func newDayRotationScheduleButton(_ sender: UIBarButtonItem) {
        tryPresentDayRotationScheduleEditor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dayRotationScheduleEditorViewController = segue.destination as? DayRotationScheduleEditorViewController {
            if let dayRotationSchedule = sender as? DayRotationSchedule {
                dayRotationScheduleEditorViewController.presetDayRotationSchedule = dayRotationSchedule
            } else {
                dayRotationScheduleEditorViewController.presetDayRotationSchedule = nil
            }
        }
    }
    
    @discardableResult func tryPresentDayRotationScheduleEditor(forDayRotationSchedule dayRotationSchedule: DayRotationSchedule? = nil) -> Bool {
        if ScheduleManagerViewController.current != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "day-rotation-schedule-editor-modal-segue", sender: dayRotationSchedule)
            }
            return true
        }
        return false
    }

}

extension ScheduleManagerViewController {
    
    private static var current_mutable: ScheduleManagerViewController?
    class var current: ScheduleManagerViewController? { current_mutable }
    
    override func viewDidLoad() {
        ScheduleManagerViewController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ScheduleManagerViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ScheduleManagerViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
