//
//  DayRotationScheduleEditorDaysTabTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayRotationScheduleEditorDaysTabTableViewController: UITableViewController {
    
    private var days: [DayRotationSchedule.Day]? {
        get { DayRotationScheduleEditorViewController.current?.pendingDays }
        set { DayRotationScheduleEditorViewController.current?.pendingDays = newValue }
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
}

extension DayRotationScheduleEditorDaysTabTableViewController {
    
    // MARK: - Define Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int { ((days?.count ?? 0) == 0) ? 0 : 1 }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? { "Days" }
    
    // MARK: - Define Cells

    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int { days?.count ?? 0 }
    
    override func tableView(_ tableView: UITableView, heightForRowAt cellIndexPath: IndexPath) -> CGFloat { 80 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt cellIndexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "day-cell", for: cellIndexPath)
        if let day = days?[cellIndexPath.row] {
            styleCell(cell, forDay: day)
        }
        return cell
    }
    
    private func styleCell(_ cell: UITableViewCell, forDay day: DayRotationSchedule.Day) {
        if let nameLabel = cell.viewWithTag(1) as? UILabel {
            nameLabel.text = day.name
        }
        if let blockCountLabel = cell.viewWithTag(2) as? UILabel {
            blockCountLabel.text = String(day.blockTimeInstances.count)
        }
    }
    
    // MARK: - Define Cell Editing
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt cellIndexPath: IndexPath) -> UITableViewCell.EditingStyle { .delete }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt cellIndexPath: IndexPath) {
        if editingStyle == .delete {
            days?.remove(at: cellIndexPath.row)
            if self.tableView.numberOfRows(inSection: 0) == 1 {
                self.tableView.deleteSections([cellIndexPath.section], with: .fade)
            } else {
                self.tableView.deleteRows(at: [cellIndexPath], with: .fade)
            }
        }
        refresh()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith cellIndexPath: IndexPath) {
        DayRotationScheduleEditorDaysTabViewController.current?.tryPresentDayEditor(forDay: days?[cellIndexPath.row])
    }
    
}

extension DayRotationScheduleEditorDaysTabTableViewController {
    
    private static var current_mutable: DayRotationScheduleEditorDaysTabTableViewController?
    class var current: DayRotationScheduleEditorDaysTabTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayRotationScheduleEditorDaysTabTableViewController.current_mutable = self
        super.viewDidLoad()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayRotationScheduleEditorDaysTabTableViewController.current_mutable = self
        super.viewDidAppear(animated)
        refresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayRotationScheduleEditorDaysTabTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
