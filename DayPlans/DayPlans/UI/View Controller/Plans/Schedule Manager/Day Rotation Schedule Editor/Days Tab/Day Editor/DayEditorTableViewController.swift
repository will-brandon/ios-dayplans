//
//  DayEditorTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayEditorTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func newBlockButtonAction(_ sender: UIButton) {
        if let blocks = DayRotationScheduleEditorViewController.current?.pendingBlocks {
            if blocks.count > 0 {
                DayEditorViewController.current?.pendingBlockTimeInstances?.append(Block.TimeInstance(block: blocks.first!, time: Time(hour: 0, minute: 0, second: 0, nanosecond: 0)))
                if let blockTimeInstanceCount = DayEditorViewController.current?.pendingBlockTimeInstances?.count {
                    DayEditorBlockManagerTableViewController.current?.addCellNeedingCompleteRefresh(atIndex: blockTimeInstanceCount - 1)
                }
                DayEditorBlockManagerTableViewController.current?.refresh()
            }
        }
    }
    
    @discardableResult func tryLoadPresetDay() -> Bool {
        if let presetDay = DayEditorViewController.current?.presetDay {
            nameTextField.text = presetDay.name
            return true
        }
        return false
    }
    
}

extension DayEditorTableViewController {
    
    private static var current_mutable: DayEditorTableViewController?
    class var current: DayEditorTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayEditorTableViewController.current_mutable = self
        super.viewDidLoad()
        tryLoadPresetDay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayEditorTableViewController.current_mutable = self
        super.viewDidAppear(animated)
        tryLoadPresetDay()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayEditorTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
