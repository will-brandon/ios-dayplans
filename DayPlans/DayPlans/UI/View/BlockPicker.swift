//
//  BlockPicker.swift
//  DayPlans
//
//  Created by Will Brandon on 10/15/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class BlockPicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var blockOptions: [Block] {
        didSet {
            self.reloadComponent(0)
        }
    }
    
    private var titles: [String] {
        var titles = [String]()
        blockOptions.forEach { titles.append($0.title) }
        return titles
    }
    
    var block: Block {
        get { blockOptions[self.selectedRow(inComponent: 0)] }
        set {
            if let selectedRowIndex = blockOptions.firstIndex(where: { $0.probablyEquals(newValue) }) {
                self.selectRow(selectedRowIndex, inComponent: 0, animated: true)
            }
        }
    }
    
    var updateEventListener: (() -> Void)?
    
    required init?(coder: NSCoder) {
        blockOptions = []
        updateEventListener = nil
        super.init(coder: coder)
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent componentIndex: Int) -> Int { titles.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow rowIndex: Int, forComponent componentIndex: Int) -> String? { titles[rowIndex] }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow rowIndex: Int, inComponent componentIndex: Int) { updateEventListener?() }
    
}
