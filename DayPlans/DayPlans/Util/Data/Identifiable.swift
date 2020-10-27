//
//  Identifiable.swift
//  DayPlans
//
//  Created by Will Brandon on 9/28/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

protocol Identifiable: Equatable {
    
    var id: UInt { get }
    
}
