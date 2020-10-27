//
//  DayRotationScheduleEditorBlocksTabTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayRotationScheduleEditorBlocksTabTableViewController: UITableViewController {
    
    private var blocks: [Block]? {
        get { DayRotationScheduleEditorViewController.current?.pendingBlocks }
        set { DayRotationScheduleEditorViewController.current?.pendingBlocks = newValue }
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
}

extension DayRotationScheduleEditorBlocksTabTableViewController {
    
    // MARK: - Define Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int { ((blocks?.count ?? 0) == 0) ? 0 : 1 }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? { "Blocks" }
    
    // MARK: - Define Cells

    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int { blocks?.count ?? 0 }
    
    override func tableView(_ tableView: UITableView, heightForRowAt cellIndexPath: IndexPath) -> CGFloat { 60 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt cellIndexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "block-cell", for: cellIndexPath)
        if let block = blocks?[cellIndexPath.row] {
            styleCell(cell, forBlock: block)
        }
        return cell
    }
    
    private func styleCell(_ cell: UITableViewCell, forBlock block: Block) {
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = block.title
        }
        if let locationNameLabel = cell.viewWithTag(2) as? UILabel {
            locationNameLabel.text = block.locationName ?? ""
        }
        if let associatedColorMarker = cell.viewWithTag(3) {
            associatedColorMarker.backgroundColor = block.associatedColor.color
        }
    }
    
    // MARK: - Define Cell Editing
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt cellIndexPath: IndexPath) -> UITableViewCell.EditingStyle { .delete }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt cellIndexPath: IndexPath) {
        if editingStyle == .delete {
            if let block = blocks?[cellIndexPath.row] {
                removeBlockTimeInstances(forBlock: block)
            }
            blocks?.remove(at: cellIndexPath.row)
            if self.tableView.numberOfRows(inSection: 0) == 1 {
                self.tableView.deleteSections([cellIndexPath.section], with: .fade)
            } else {
                self.tableView.deleteRows(at: [cellIndexPath], with: .fade)
            }
        }
        refresh()
    }
    
    private func removeBlockTimeInstances(forBlock block: Block) {
        for dayIndex in 0..<(DayRotationScheduleEditorViewController.current?.pendingDays?.count ?? 0) {
            let day = DayRotationScheduleEditorViewController.current!.pendingDays![dayIndex]
            var newBlockTimeInstances = [Block.TimeInstance]()
            day.blockTimeInstances.forEach {
                if !$0.block.probablyEquals(block) {
                    newBlockTimeInstances.append($0)
                }
            }
            if newBlockTimeInstances.count != day.blockTimeInstances.count {
                DayRotationScheduleEditorViewController.current?.pendingDays?[dayIndex] = DayRotationSchedule.Day(name: day.name, blockTimeInstances: newBlockTimeInstances)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith cellIndexPath: IndexPath) {
        DayRotationScheduleEditorBlocksTabViewController.current?.tryPresentBlockEditor(forBlock: blocks?[cellIndexPath.row])
    }
    
}

extension DayRotationScheduleEditorBlocksTabTableViewController {
    
    private static var current_mutable: DayRotationScheduleEditorBlocksTabTableViewController?
    class var current: DayRotationScheduleEditorBlocksTabTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayRotationScheduleEditorBlocksTabTableViewController.current_mutable = self
        super.viewDidLoad()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayRotationScheduleEditorBlocksTabTableViewController.current_mutable = self
        super.viewDidAppear(animated)
        refresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayRotationScheduleEditorBlocksTabTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
