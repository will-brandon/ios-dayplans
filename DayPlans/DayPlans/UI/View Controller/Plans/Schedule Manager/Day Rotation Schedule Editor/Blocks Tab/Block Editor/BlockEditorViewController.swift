//
//  BlockEditorViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class BlockEditorViewController: UIViewController {
    
    var presetBlock: Block?
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
       if let tableViewController = BlockEditorTableViewController.current {
            let title = ((tableViewController.titleTextField.text != nil) && (tableViewController.titleTextField.text != "")) ? tableViewController.titleTextField.text! : "Untitled Block"
            let locationName = tableViewController.locationNameTextField.text
            let description = tableViewController.descriptionTextField.text
            let associatedColor = tableViewController.associatedColorPicker.associatedColor
            let newBlock = Block(title: title, locationName: locationName, description: description, associatedColor: associatedColor)
            if let presetBlock = presetBlock {
                modifyBlockTimeInstances(forOldBlock: presetBlock, toNewBlock: newBlock)
                if let replacementIndex = DayRotationScheduleEditorViewController.current?.pendingBlocks?.firstIndex(where: { $0.probablyEquals(presetBlock) }) {
                    DayRotationScheduleEditorViewController.current?.pendingBlocks?[replacementIndex] = newBlock
                }
            } else {
                DayRotationScheduleEditorViewController.current?.pendingBlocks?.append(newBlock)
            }
            DayRotationScheduleEditorBlocksTabTableViewController.current?.refresh()
            self.dismiss(animated: true)
        }
    }
    
    private func modifyBlockTimeInstances(forOldBlock oldBlock: Block, toNewBlock newBlock: Block) {
        for dayIndex in 0..<(DayRotationScheduleEditorViewController.current?.pendingDays?.count ?? 0) {
            let day = DayRotationScheduleEditorViewController.current!.pendingDays![dayIndex]
            var newBlockTimeInstances = [Block.TimeInstance]()
            day.blockTimeInstances.forEach {
                if $0.block.probablyEquals(oldBlock) {
                    newBlockTimeInstances.append(Block.TimeInstance(block: newBlock, time: $0.time))
                } else {
                    newBlockTimeInstances.append($0)
                }
            }
            if newBlockTimeInstances.count != day.blockTimeInstances.count {
                DayRotationScheduleEditorViewController.current?.pendingDays?[dayIndex] = DayRotationSchedule.Day(name: day.name, blockTimeInstances: newBlockTimeInstances)
            }
        }
    }
    
}

extension BlockEditorViewController {
    
    private static var current_mutable: BlockEditorViewController?
    class var current: BlockEditorViewController? { current_mutable }
    
    override func viewDidLoad() {
        BlockEditorViewController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BlockEditorViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        BlockEditorViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
