//
//  DayRotationScheduleEditorBlocksTabViewController.swift
//  DayPlans
//
//  Created by Will Brandon on 10/17/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class DayRotationScheduleEditorBlocksTabViewController: UIViewController {

    @IBAction func newBlockButtonAction(_ sender: UIBarButtonItem) {
        tryPresentBlockEditor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let blockEditorViewController = segue.destination as? BlockEditorViewController {
            if let block = sender as? Block {
                blockEditorViewController.presetBlock = block
            } else {
                blockEditorViewController.presetBlock = nil
            }
        }
    }
    
    @discardableResult func tryPresentBlockEditor(forBlock block: Block? = nil) -> Bool {
        if DayRotationScheduleEditorBlocksTabViewController.current != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "block-editor-modal-segue", sender: block)
            }
            return true
        }
        return false
    }
    
}

extension DayRotationScheduleEditorBlocksTabViewController {
    
    private static var current_mutable: DayRotationScheduleEditorBlocksTabViewController?
    class var current: DayRotationScheduleEditorBlocksTabViewController? { current_mutable }
    
    override func viewDidLoad() {
        DayRotationScheduleEditorBlocksTabViewController.current_mutable = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DayRotationScheduleEditorBlocksTabViewController.current_mutable = self
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DayRotationScheduleEditorBlocksTabViewController.current_mutable = nil
        super.viewDidDisappear(animated)
    }
    
}
