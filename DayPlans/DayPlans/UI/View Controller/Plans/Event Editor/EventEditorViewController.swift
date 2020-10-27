//
//  EventEditorViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/14/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class EventEditorViewController: UIViewController {
    
    var presetEvent: Event?
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        if let tableViewController = EventEditorTableViewController.current {
            let dateTime = DateTime(forDate: tableViewController.datePicker.date).startOfThisMinute
            let title = ((tableViewController.titleTextField.text != nil) && (tableViewController.titleTextField.text != "")) ? tableViewController.titleTextField.text! : "Untitled Event"
            let locationName = tableViewController.locationNameTextField.text
            let description = tableViewController.descriptionTextField.text
            let associatedColor = tableViewController.associatedColorPicker.associatedColor
            if let presetEvent = presetEvent {
                Planner.current.remove(event: presetEvent)
            }
            Planner.current.add(event: Event(dateTime: dateTime, title: title, locationName: locationName, description: description, associatedColor: associatedColor))
            PlansTableViewController.current?.refresh()
            self.dismiss(animated: true)
        }
    }
    
}

extension EventEditorViewController {
    
    private static var current_mutable: EventEditorViewController?
    class var current: EventEditorViewController? { current_mutable }
    
    override func viewDidLoad() {
        EventEditorViewController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        EventEditorViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        EventEditorViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
