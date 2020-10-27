//
//  ObservableDatePicker.swift
//  DayPlans
//
//  Created by Will Brandon on 10/18/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import UIKit

class ObservableDatePicker: UIDatePicker {
    
    var updateEventListener: (() -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(ObservableDatePicker.didChangeValue(_:)), for: .valueChanged)
    }
    
    @objc func didChangeValue(_ sender: UIDatePicker) {
        updateEventListener?()
    }

}
