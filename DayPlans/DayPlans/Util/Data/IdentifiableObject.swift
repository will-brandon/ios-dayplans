//
//  IdentifiableObject.swift
//  DayPlans
//
//  Created by Will Brandon on 9/19/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class IdentifiableObject: Identifiable {
    
    static let ID_RANGE = UInt.min...UInt.max
    
    private static var usedIDs_mutable: [UInt] = []
    static var usedIDs: [UInt] { usedIDs_mutable }
    
    private static func tryClaimID(_ id: UInt) -> UInt? {
        if !usedIDs.contains(id) {
            usedIDs_mutable.append(id)
            return id
        }
        return nil
    }
    
    private static func claimRandomID() -> UInt {
        if let id = tryClaimID(UInt.random(in: ID_RANGE)) {
            return id
        }
        return claimRandomID()
    }
    
    static func ==(_ object1: IdentifiableObject, _ object2: IdentifiableObject) -> Bool { object1.id == object2.id }
    
    let id: UInt
    
    init() {
        id = IdentifiableObject.claimRandomID()
    }
    
    init?(withID id: UInt) {
        if let id = IdentifiableObject.tryClaimID(id) {
            self.id = id
        } else {
            return nil
        }
    }
    
}
