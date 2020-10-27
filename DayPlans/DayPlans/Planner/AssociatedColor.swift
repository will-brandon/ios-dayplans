//
//  AssociatedColorOption.swift
//  DayPlans
//
//  Created by Will Brandon on 10/15/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UIKit

struct AssociatedColor: Equatable {
    
    static let black = AssociatedColor(name: "black", color: UIColor.black)
    static let darkGray = AssociatedColor(name: "dark gray", color: UIColor.darkGray)
    static let lightGray = AssociatedColor(name: "light gray", color: UIColor.lightGray)
    static let white = AssociatedColor(name: "white", color: UIColor.white)
    static let gray = AssociatedColor(name: "gray", color: UIColor.gray)
    static let red = AssociatedColor(name: "red", color: UIColor.red)
    static let green = AssociatedColor(name: "green", color: UIColor.green)
    static let blue = AssociatedColor(name: "blue", color: UIColor.blue)
    static let cyan = AssociatedColor(name: "cyan", color: UIColor.cyan)
    static let yellow = AssociatedColor(name: "yellow", color: UIColor.yellow)
    static let magenta = AssociatedColor(name: "magenta", color: UIColor.magenta)
    static let orange = AssociatedColor(name: "orange", color: UIColor.orange)
    static let purple = AssociatedColor(name: "purple", color: UIColor.purple)
    static let brown = AssociatedColor(name: "brown", color: UIColor.brown)
    
    static let options: [AssociatedColor] = [.black, .darkGray, .lightGray, .white, .gray, .red, .green, .blue, .cyan, .yellow, .magenta, .orange, .purple, .brown]
    
    static func forName(_ name: String) -> AssociatedColor? { options.first { $0.name == name } }
    
    static func random() -> AssociatedColor { options[Int.random(in: 0..<options.count)] }
    
    static func ==(_ associatedColor1: AssociatedColor, _ associatedColor2: AssociatedColor) -> Bool { associatedColor1.name == associatedColor2.name }
    
    let name: String
    let color: UIColor
    
    private init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
    
}
