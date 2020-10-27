//
//  AssociatedColorPicker.swift
//  DayPlans
//
//  Created by Will Brandon on 10/15/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class AssociatedColorPicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private lazy var titles: [String] = {
        var titles = ["Random"]
        AssociatedColor.options.forEach { titles.append($0.name.capitalized) }
        return titles
    }()
    
    var associatedColor: AssociatedColor {
        get {
            let selectedRowIndex = self.selectedRow(inComponent: 0)
            return (selectedRowIndex == 0) ? AssociatedColor.random() : AssociatedColor.options[selectedRowIndex - 1]
        }
        set {
            if let selectedRowIndex = AssociatedColor.options.firstIndex(where: { $0 == newValue }) {
                self.selectRow(selectedRowIndex + 1, inComponent: 0, animated: true)
            }
        }
    }
    
    var updateEventListener: (() -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent componentIndex: Int) -> Int { titles.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow rowIndex: Int, forComponent componentIndex: Int) -> String? { titles[rowIndex] }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow rowIndex: Int, inComponent componentIndex: Int) { updateEventListener?() }
    
}
