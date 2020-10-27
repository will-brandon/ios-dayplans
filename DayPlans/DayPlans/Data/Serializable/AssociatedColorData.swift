//
//  ColorData.swift
//  DayPlans
//
//  Created by Will Brandon on 10/2/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit

struct AssociatedColorData: Codable {
    
    let name: String
    
    init?(name: String) {
        if AssociatedColor.forName(name) == nil {
            return nil
        }
        self.name = name
    }
    
    init(fromAssociatedColor associatedColor: AssociatedColor) {
        name = associatedColor.name
    }
    
    func associatedColor() -> AssociatedColor { AssociatedColor.forName(name)! }
    
}
