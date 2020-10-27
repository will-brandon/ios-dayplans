//
//  EventEditorTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class EventEditorTableViewController: UITableViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var associatedColorPicker: AssociatedColorPicker!
    
    @discardableResult func tryLoadPresetEvent() -> Bool {
        if let presetEvent = EventEditorViewController.current?.presetEvent {
            datePicker.date = presetEvent.dateTime.date
            titleTextField.text = presetEvent.title
            locationNameTextField.text = presetEvent.locationName
            descriptionTextField.text = presetEvent.description
            associatedColorPicker.associatedColor = presetEvent.associatedColor
            return true
        }
        return false
    }
    
}

extension EventEditorTableViewController {
    
    private static var current_mutable: EventEditorTableViewController?
    class var current: EventEditorTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        EventEditorTableViewController.current_mutable = self
        super.viewDidLoad()
        datePicker.locale = UserPreferences.current.timeStyleResultingLocale
        tryLoadPresetEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        EventEditorTableViewController.current_mutable = self
        super.viewDidAppear(animated)
        tryLoadPresetEvent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        EventEditorTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
