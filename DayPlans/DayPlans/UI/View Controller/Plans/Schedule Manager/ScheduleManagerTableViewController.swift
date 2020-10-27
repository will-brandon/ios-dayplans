//
//  ScheduleManagerTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/16/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class ScheduleManagerTableViewController: UITableViewController {
    
    func refresh() {
        self.tableView.reloadData()
    }
    
}

extension ScheduleManagerTableViewController {
    
    // MARK: - Define Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int { (Planner.current.dayRotationSchedules.count == 0) ? 0 : 1 }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? { "Day Rotation Schedules" }
    
    // MARK: - Define Cells

    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int { Planner.current.dayRotationSchedules.count }
    
    override func tableView(_ tableView: UITableView, heightForRowAt cellIndexPath: IndexPath) -> CGFloat { 80 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt cellIndexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "day-rotation-schedule-cell", for: cellIndexPath)
        styleCell(cell, forDayRotationSchedule: Planner.current.dayRotationSchedules[cellIndexPath.row])
        return cell
    }
    
    private func styleCell(_ cell: UITableViewCell, forDayRotationSchedule dayRotationSchedule: DayRotationSchedule) {
        if let nameLabel = cell.viewWithTag(1) as? UILabel {
            nameLabel.text = dayRotationSchedule.name ?? ""
        }
        if let dateRangeLabel = cell.viewWithTag(2) as? UILabel {
            dateRangeLabel.text = "\(dayRotationSchedule.firstDay.dayAbbreviatedDisplayString) - \(dayRotationSchedule.lastDay.dayAbbreviatedDisplayString)"
        }
        if let daysInRotationCountLabel = cell.viewWithTag(3) as? UILabel {
            daysInRotationCountLabel.text = String(dayRotationSchedule.days.count)
        }
    }
    
    // MARK: - Define Cell Editing
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt cellIndexPath: IndexPath) -> UITableViewCell.EditingStyle { .delete }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt cellIndexPath: IndexPath) {
        if editingStyle == .delete {
            Planner.current.remove(dayRotationSchedule: Planner.current.dayRotationSchedules[cellIndexPath.row])
            if self.tableView.numberOfRows(inSection: 0) == 1 {
                self.tableView.deleteSections([cellIndexPath.section], with: .fade)
            } else {
                self.tableView.deleteRows(at: [cellIndexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith cellIndexPath: IndexPath) {
        ScheduleManagerViewController.current?.tryPresentDayRotationScheduleEditor(forDayRotationSchedule: Planner.current.dayRotationSchedules[cellIndexPath.row])
    }
    
}

extension ScheduleManagerTableViewController {
    
    private static var current_mutable: ScheduleManagerTableViewController?
    class var current: ScheduleManagerTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        ScheduleManagerTableViewController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ScheduleManagerTableViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ScheduleManagerTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
