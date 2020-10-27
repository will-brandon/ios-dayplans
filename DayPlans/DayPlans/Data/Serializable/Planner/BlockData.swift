//
//  BlockData.swift
//  DayPlans
//
//  Created by Will Brandon on 10/9/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

struct BlockData: Codable {
    
    struct TimeInstanceData: Codable {
        
        let blockData: BlockData
        let time: Time
        
        init(blockData: BlockData, time: Time) {
            self.blockData = blockData
            self.time = time
        }
        
        init(fromTimeInstance timeInstance: Block.TimeInstance) {
            blockData = BlockData(fromBlock: timeInstance.block)
            time = timeInstance.time
        }
        
        func timeInstance() -> Block.TimeInstance { Block.TimeInstance(block: blockData.block(), time: time) }
        
    }
    
    var title: String
    var locationName: String?
    var description: String?
    var associatedColorData: AssociatedColorData
    
    init(title: String, locationName: String?, description: String?, associatedColorData: AssociatedColorData) {
        self.title = title
        self.locationName = locationName
        self.description = description
        self.associatedColorData = associatedColorData
    }
    
    init(fromBlock block: Block) {
        self.title = block.title
        self.locationName = block.locationName
        self.description = block.description
        self.associatedColorData = AssociatedColorData(fromAssociatedColor: block.associatedColor)
    }
    
    func block() -> Block { Block(title: title, locationName: locationName, description: description, associatedColor: associatedColorData.associatedColor()) }
    
}
