//
//  DayEditorBlockManagerTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayEditorBlockManagerTableViewController: UITableViewController {
    
    private var cellsNeedingCompleteRefresh: [Bool] = []
    
    private var blockTimeInstances: [Block.TimeInstance]? {
        get { DayEditorViewController.current?.pendingBlockTimeInstances }
        set {
            DayEditorViewController.current?.pendingBlockTimeInstances = newValue
        }
    }
    
    func addCellNeedingCompleteRefresh(atIndex index: Int) {
        cellsNeedingCompleteRefresh.insert(true, at: index)
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
}

extension DayEditorBlockManagerTableViewController {
    
    // MARK: - Define Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int { ((blockTimeInstances?.count ?? 0) == 0) ? 0 : 1 }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? { "Blocks in This Day" }
    
    // MARK: - Define Cells

    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int { blockTimeInstances?.count ?? 0 }
    
    override func tableView(_ tableView: UITableView, heightForRowAt cellIndexPath: IndexPath) -> CGFloat { 100 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt cellIndexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "block-time-instance-cell", for: cellIndexPath)
        if let blockTimeInstance = blockTimeInstances?[cellIndexPath.row] {
            styleCell(cell, forBlockTimeInstance: blockTimeInstance, atCellIndexPath: cellIndexPath)
        }
        return cell
    }
    
    private func styleCell(_ cell: UITableViewCell, forBlockTimeInstance blockTimeInstance: Block.TimeInstance, atCellIndexPath cellIndexPath: IndexPath) {
        if let blockPicker = cell.viewWithTag(1) as? BlockPicker {
            blockPicker.blockOptions = DayRotationScheduleEditorViewController.current?.pendingBlocks ?? []
            blockPicker.updateEventListener = {
                if let previousTime = DayEditorViewController.current?.pendingBlockTimeInstances?[cellIndexPath.row].time {
                    DayEditorViewController.current?.pendingBlockTimeInstances?[cellIndexPath.row] = Block.TimeInstance(block: blockPicker.block, time: previousTime)
                }
                self.refresh()
            }
            if cellsNeedingCompleteRefresh[cellIndexPath.row] {
                blockPicker.block = blockTimeInstance.block
                // scellsNeedingCompleteRefresh set to false at the end
            }
            if let associatedColorMarker = cell.viewWithTag(3) {
                associatedColorMarker.backgroundColor = blockPicker.block.associatedColor.color
            }
        }
        if let datePicker = cell.viewWithTag(2) as? ObservableDatePicker {
            datePicker.updateEventListener = {
                if let previousBlock = DayEditorViewController.current?.pendingBlockTimeInstances?[cellIndexPath.row].block {
                    DayEditorViewController.current?.pendingBlockTimeInstances?[cellIndexPath.row] = Block.TimeInstance(block: previousBlock, time: DateTime(forDate: datePicker.date).startOfThisMinute.time)
                }
                self.refresh()
            }
            if cellsNeedingCompleteRefresh[cellIndexPath.row] {
                datePicker.date = DateTime.now.dateTimeOfThisDay(atTime: blockTimeInstance.time).date
                // cellsNeedingCompleteRefresh set to false at the end
            }
        }
        if cellsNeedingCompleteRefresh[cellIndexPath.row] {
            cellsNeedingCompleteRefresh[cellIndexPath.row] = false
        }
    }
    
    // MARK: - Define Cell Editing
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt cellIndexPath: IndexPath) -> UITableViewCell.EditingStyle { .delete }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? { "Remove" }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt cellIndexPath: IndexPath) {
        if editingStyle == .delete {
            blockTimeInstances?.remove(at: cellIndexPath.row)
            cellsNeedingCompleteRefresh.remove(at: cellIndexPath.row)
            if self.tableView.numberOfRows(inSection: 0) == 1 {
                self.tableView.deleteSections([cellIndexPath.section], with: .fade)
            } else {
                self.tableView.deleteRows(at: [cellIndexPath], with: .fade)
            }
        }
        refresh()
    }
    
}

extension DayEditorBlockManagerTableViewController {
    
    private static var current_mutable: DayEditorBlockManagerTableViewController?
    class var current: DayEditorBlockManagerTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayEditorBlockManagerTableViewController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayEditorBlockManagerTableViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for _ in 0..<(blockTimeInstances?.count ?? 0) {
            cellsNeedingCompleteRefresh.append(true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayEditorBlockManagerTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
