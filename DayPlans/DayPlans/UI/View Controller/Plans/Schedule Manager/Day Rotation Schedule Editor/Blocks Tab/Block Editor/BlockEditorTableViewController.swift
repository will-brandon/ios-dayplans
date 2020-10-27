//
//  BlockEditorTableViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class BlockEditorTableViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var associatedColorPicker: AssociatedColorPicker!
    
    @discardableResult func tryLoadPresetBlock() -> Bool {
        if let presetBlock = BlockEditorViewController.current?.presetBlock {
            titleTextField.text = presetBlock.title
            locationNameTextField.text = presetBlock.locationName
            descriptionTextField.text = presetBlock.description
            associatedColorPicker.associatedColor = presetBlock.associatedColor
            return true
        }
        return false
    }
    
}

extension BlockEditorTableViewController {
    
    private static var current_mutable: BlockEditorTableViewController?
    class var current: BlockEditorTableViewController? { current_mutable }
    
    override func viewDidLoad() {
        BlockEditorTableViewController.current_mutable = self
        super.viewDidLoad()
        tryLoadPresetBlock()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BlockEditorTableViewController.current_mutable = self
        super.viewDidAppear(animated)
        tryLoadPresetBlock()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        BlockEditorTableViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
