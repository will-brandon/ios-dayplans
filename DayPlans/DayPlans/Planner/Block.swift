//
//  Block.swift
//  DayPlans
//
//  Created by Will Brandon on 9/1/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit

struct Block {
    
    struct TimeInstance {
        
        let block: Block
        let time: Time
        
    }
    
    var title: String
    var locationName: String?
    var description: String?
    var associatedColor: AssociatedColor
    
    init(title: String, locationName: String? = nil, description: String? = nil, associatedColor: AssociatedColor? = nil) {
        self.title = title
        self.locationName = locationName
        self.description = description
        if associatedColor != nil {
            self.associatedColor = associatedColor!
        } else {
            self.associatedColor = AssociatedColor.random()
        }
    }
    
    func probablyEquals(_ otherBlock: Block) -> Bool { (title == otherBlock.title) && (locationName == otherBlock.locationName) && (description == otherBlock.description) && (associatedColor == otherBlock.associatedColor) }
    
    func timeInstance(forTime time: Time) -> TimeInstance { TimeInstance(block: self, time: time) }
    
    func event(atDateTime dateTime: DateTime) -> Event { Event(dateTime: dateTime, title: title, locationName: locationName, description: description, associatedColor: associatedColor) }
    
}
