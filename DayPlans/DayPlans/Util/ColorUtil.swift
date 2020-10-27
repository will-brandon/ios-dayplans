//
//  ColorUtil.swift
//  DayPlans
//
//  Created by Will Brandon on 7/20/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit

class ColorUtil {
    
    class func randomColor(
        redRange: ClosedRange<CGFloat>,
        greenRange: ClosedRange<CGFloat>,
        blueRange: ClosedRange<CGFloat>,
        alphaRange: ClosedRange<CGFloat>
    ) -> UIColor {
        let red = CGFloat.random(in: redRange)
        let green = CGFloat.random(in: greenRange)
        let blue = CGFloat.random(in: blueRange)
        let alpha = CGFloat.random(in: alphaRange)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func randomColor() -> UIColor { randomColor(redRange: 0...1, greenRange: 0...1, blueRange: 0...1, alphaRange: 0...1) }
    
    class func randomOpaqueColor() -> UIColor { randomColor(redRange: 0...1, greenRange: 0...1, blueRange: 0...1, alphaRange: 1...1) }
    
}
