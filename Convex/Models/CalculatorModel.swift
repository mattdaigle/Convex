//
//  CalculatorModel.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import Foundation

struct CalculatorModel {
    
    enum Constants {
        static let cpuRegisterSize = String(UInt.max, radix: 2).count
    }
    
    let bases = Base.allCases
    let numbers: [[UInt]] = [
        [7, 8,   9,   0xF],
        [4, 5,   6,   0xE],
        [1, 2,   3,   0xD],
        [0, 0xA, 0xB, 0xC]
    ]
    
    func flipBytes(for value: UInt) -> UInt {
        guard value > 0 else {
            return value
        }
        
        // Determine how many bits the number is and pad with zeroes to fill out the occupied bytes.
        let binaryString = String(value, radix: 2)
        let bitCount = binaryString.count
        let partialByteBitCount = bitCount % 8
        let bitPaddingCount = partialByteBitCount == 0 ? 0 : 8 - partialByteBitCount
        let paddedBinaryString = String(repeating: "0", count: bitPaddingCount) + binaryString
        let paddedNumberByteCount = paddedBinaryString.count / 8
        let rightShiftCount = Constants.cpuRegisterSize - paddedNumberByteCount * 8
        
        // A single byte flipped is itself.
        guard paddedNumberByteCount > 1 else {
            return value
        }
        
        return value.byteSwapped >> rightShiftCount
    }
    
    func twosComplement(value: UInt) -> UInt {
        guard value > 0 else {
            return value
        }
        
        // Check for overflow before performing the operation. The bitwise NOT operator (~) inverts all bits in a number.
        let overflowValue = UInt.max - ~value
        
        guard overflowValue >= 1 else {
            return value
        }
        
        return ~value + 1
    }
    
    func appendDigit(_ digit: String, to value: UInt, base: Base) -> UInt {
        guard value > 0 || digit != "0" else {
            return value
        }
        
        let numberToAppendAsUInt = strtoul(digit, nil, 16)
        let radix = base.radixValue
        
        // Check for overflow.
        guard UInt.max / value >= radix && UInt.max - value * radix >= numberToAppendAsUInt else {
            return value
        }
        
        return value * radix + numberToAppendAsUInt
    }
}
