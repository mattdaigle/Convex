//
//  CalculatorModel.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import Foundation

struct CalculatorModel {
    
    let bases = Base.allCases
    let operations = Operation.allCases.filter { $0 != .ones }
    let numbers: [[UInt]] = [
        [7, 8,   9,   0xF],
        [4, 5,   6,   0xE],
        [1, 2,   3,   0xD],
        [0, 0xA, 0xB, 0xC]
    ]
    
    // MARK: - Actions
    
    func append(_ digit: UInt, to value: UInt, radix: Int) -> UInt {
        guard value > 0 || digit > 0 else {
            return value
        }
        
        // Check for overflow.
        guard value == 0 || UInt.max / value >= UInt(radix) else {
            return value
        }
        guard UInt.max - value * UInt(radix) >= digit else {
            return value
        }
        
        return value * UInt(radix) + digit
    }
    
    func removeLeastSignificantDigit(from value: UInt, radix: Int) -> UInt {
        value / UInt(radix)
    }
    
    func perform(_ operation: Operation, on value: UInt) -> UInt {
        operation.function(value)
    }
}
