//
//  CalculatorModel.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import Foundation

@Observable
final class CalculatorModel {
    
    private(set) var currentValue: UInt = 0
    private(set) var currentBase: Base = .hex
    let bases = Base.allCases
    let operations = Operations.allCases.filter { $0 != .ones }
    let numbers: [[UInt]] = [
        [7, 8,   9,   0xF],
        [4, 5,   6,   0xE],
        [1, 2,   3,   0xD],
        [0, 0xA, 0xB, 0xC]
    ]
    private var radix: UInt {
        UInt(currentBase.radix)
    }
    
    // MARK: - Actions
    
    func updateBaseValue(to base: Base) {
        currentBase = base
    }
    
    func append(_ digit: UInt) {
        guard currentValue > 0 || digit > 0 else {
            return
        }
                
        // Check for overflow.
        guard currentValue == 0 || UInt.max / currentValue >= radix else {
            return
        }
        guard UInt.max - currentValue * radix >= digit else {
            return
        }
        
        currentValue = currentValue * radix + digit
    }
    
    func removeLeastSignificantDigit() {
        currentValue = currentValue / radix
    }
    
    func paste(value: UInt) {
        currentValue = value
    }
    
    func clear() {
        currentValue = 0
    }
    
    func perform(_ operation: Operations) {
        currentValue = operation.function(currentValue)
    }
}
