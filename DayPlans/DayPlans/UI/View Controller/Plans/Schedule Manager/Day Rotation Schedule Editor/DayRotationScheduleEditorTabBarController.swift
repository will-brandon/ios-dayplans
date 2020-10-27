//
//  DayRotationScheduleEditorTabBarController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayRotationScheduleEditorTabBarController: UITabBarController {

    func nextTab() {
        self.selectedIndex += 1
        tabDidChange()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) { tabDidChange() }
    
    private func tabDidChange() {
        DayRotationScheduleEditorGeneralTabTableViewController.current?.contributeInputs()
    }

}

extension DayRotationScheduleEditorTabBarController {
    
    private static var current_mutable: DayRotationScheduleEditorTabBarController?
    class var current: DayRotationScheduleEditorTabBarController? { current_mutable }
    
    override func viewDidLoad() {
        DayRotationScheduleEditorTabBarController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayRotationScheduleEditorTabBarController.current_mutable = self
        super.viewDidAppear(animated)
        tabDidChange()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayRotationScheduleEditorTabBarController.current_mutable = nil
        super.viewDidDisappear(animated)
        tabDidChange()
    }
    
}

