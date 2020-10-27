//
//  PlansViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/15/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class PlansViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventEditorViewController = segue.destination as? EventEditorViewController {
            if let event = sender as? Event {
                eventEditorViewController.presetEvent = event
            } else {
                eventEditorViewController.presetEvent = nil
            }
        }
    }
    
    @discardableResult func tryPresentScheduleManager() -> Bool {
        if PlansViewController.current != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "schedule-manager-segue", sender: nil)
            }
            return true
        }
        return false
    }
    
    @discardableResult func tryPresentEventEditor(forEvent event: Event? = nil) -> Bool {
        if PlansViewController.current != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "event-editor-modal-segue", sender: event)
            }
            return true
        }
        return false
    }
    
    @IBAction func scheduleManagerButton(_ sender: UIBarButtonItem) {
        tryPresentScheduleManager()
    }
    
    @IBAction func newEventButtonAction(_ sender: UIBarButtonItem) {
        tryPresentEventEditor()
    }
    
    @IBAction func reloadButtonAction(_ sender: UIBarButtonItem) {
        PlansTableViewController.current?.refresh()
    }

    @IBAction func scrollToTodayButtonAction(_ sender: UIBarButtonItem) {
        PlansTableViewController.current?.scrollToToday()
    }
    
}

extension PlansViewController {
    
    private static var current_mutable: PlansViewController?
    class var current: PlansViewController? { current_mutable }
    
    override func viewDidLoad() {
        PlansViewController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PlansViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        PlansViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
