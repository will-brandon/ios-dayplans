//
//  PlansTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 7/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class PlansTableViewController: UITableViewController {
    
    struct Section {
        
        let dateTime: DateTime
        let events: [Event]
        
        var title: String { dateTime.dayLongDisplayString }
        
    }
    
    private var eventsGroupedByDayDate: [Date:[Event]] { Planner.current.eventsGroupedByDayDate }
    private var sections: [Section] = []
    
    var sectionIndexOfToday: Int? {
        for sectionIndex in 0..<sections.count {
            if sections[sectionIndex].dateTime.isToday {
                return sectionIndex
            }
        }
        return nil
    }
    
    func refreshData() {
        sections = eventsGroupedByDayDate.map({ Section(dateTime: DateTime(forDate: $0), events: $1) })
        sections.sort { $1.dateTime > $0.dateTime }
    }
    
    func refresh() {
        refreshData()
        self.tableView.reloadData()
    }
    
    func scrollToToday() {
        if let sectionIndexOfToday = sectionIndexOfToday {
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: sectionIndexOfToday), at: .top, animated: true)
            }
        }
    }
    
}

extension PlansTableViewController {
    
    // MARK: - Define Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? { sections[sectionIndex].title }
    
    // MARK: - Define Cells

    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int { sections[sectionIndex].events.count }
    
    override func tableView(_ tableView: UITableView, heightForRowAt cellIndexPath: IndexPath) -> CGFloat { 60 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt cellIndexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "event-cell", for: cellIndexPath)
        styleCell(cell, forEvent: sections[cellIndexPath.section].events[cellIndexPath.row])
        return cell
    }
    
    private func styleCell(_ cell: UITableViewCell, forEvent event: Event) {
        if event.dateTime.hasPassed {
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = .white
        }
        if let timeLabel = cell.viewWithTag(1) as? UILabel {
            timeLabel.text = event.preferredTimeStyleDisplayString
        }
        if let eventNameLabel = cell.viewWithTag(2) as? UILabel {
            eventNameLabel.text = event.title
        }
        if let eventLocationNameLabel = cell.viewWithTag(3) as? UILabel {
            eventLocationNameLabel.text = event.locationName
        }
        if let imageView = cell.viewWithTag(4) as? UIImageView {
            imageView.image = (event.associatedSchedule is IndividualEventSchedule) ? Properties.UI_PLANS_TABLE_INDIVIDUAL_EVENT_ICON_IMAGE : Properties.UI_PLANS_TABLE_SCHEDULE_EVENT_ICON_IMAGE
        }
        if let colorMarker = cell.viewWithTag(5) {
            colorMarker.backgroundColor = event.associatedColor.color
        }
    }
    
    // MARK: - Define Cell Editing
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt cellIndexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return (sections[cellIndexPath.section].events[cellIndexPath.row].associatedSchedule is IndividualEventSchedule) ? .delete : .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt cellIndexPath: IndexPath) {
        if editingStyle == .delete {
            let event = sections[cellIndexPath.section].events[cellIndexPath.row]
            Planner.current.remove(event: event)
            refreshData()
            if self.tableView.numberOfRows(inSection: cellIndexPath.section) == 1 {
                self.tableView.deleteSections([cellIndexPath.section], with: .fade)
            } else {
                self.tableView.deleteRows(at: [cellIndexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith cellIndexPath: IndexPath) {
        let event = sections[cellIndexPath.section].events[cellIndexPath.row]
        if let dayRotationSchedule = event.associatedSchedule as? DayRotationSchedule {
            if PlansViewController.current?.tryPresentScheduleManager() ?? false {
                DispatchQueue(label: "secondary-segue-queue").async {
                    while ScheduleManagerViewController.current == nil {}
                    ScheduleManagerViewController.current?.tryPresentDayRotationScheduleEditor(forDayRotationSchedule: dayRotationSchedule)
                }
            }
        } else {
            PlansViewController.current?.tryPresentEventEditor(forEvent: event)
        }
    }
    
}

extension PlansTableViewController {
    
    private static var current_mutable: PlansTableViewController?
    class var current: PlansTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        PlansTableViewController.current_mutable = self
        super.viewDidLoad()
        refreshData()
        scrollToToday()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PlansTableViewController.current_mutable = self
        refresh()
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        PlansTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
