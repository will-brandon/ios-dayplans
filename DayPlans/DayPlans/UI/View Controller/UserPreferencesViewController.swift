//
//  UserPreferencesViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/15/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class UserPreferencesViewController: UIViewController {

    @IBOutlet weak var timeStyleSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeStyleSegmentedControl.selectedSegmentIndex = (UserPreferences.current.timeStyle == .civil) ? 0 : 1
    }

    @IBAction func timeStyleSegmentedControlAction(_ sender: UISegmentedControl) {
        UserPreferences.current.timeStyle = (sender.selectedSegmentIndex == 0) ? .civil : .military
    }
}
