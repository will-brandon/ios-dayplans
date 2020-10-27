//
//  DayRotationScheduleEditorDaysTabViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayRotationScheduleEditorDaysTabViewController: UIViewController {

    @IBAction func newDayButtonAction(_ sender: UIBarButtonItem) {
        tryPresentDayEditor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dayEditorViewController = segue.destination as? DayEditorViewController {
            if let day = sender as? DayRotationSchedule.Day {
                dayEditorViewController.presetDay = day
            } else {
                dayEditorViewController.presetDay = nil
            }
        }
    }
    
    @discardableResult func tryPresentDayEditor(forDay day: DayRotationSchedule.Day? = nil) -> Bool {
        if DayRotationScheduleEditorDaysTabViewController.current != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "day-editor-modal-segue", sender: day)
            }
            return true
        }
        return false
    }

}

extension DayRotationScheduleEditorDaysTabViewController {
    
    private static var current_mutable: DayRotationScheduleEditorDaysTabViewController?
    class var current: DayRotationScheduleEditorDaysTabViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayRotationScheduleEditorDaysTabViewController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayRotationScheduleEditorDaysTabViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayRotationScheduleEditorDaysTabViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
