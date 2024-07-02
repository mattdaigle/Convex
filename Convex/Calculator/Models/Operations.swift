//
//  Operations.swift
//  Convex
//
//  Created by Matt Daigle on 7/1/24.
//

import Foundation

enum Operations: CaseIterable {
    case flip
    case twos
    case ones
    case leftShift
    case rightShift
    
    var title: String {
        switch self {
        case .flip:
            "flip"
        case .twos:
            "2's"
        case .ones:
            "1's"
        case .leftShift:
            "<<"
        case .rightShift:
            ">>"
        }
    }
    
    var function: (UInt) -> UInt {
        switch self {
        case .flip:
            flipBytes
        case .twos:
            twosComplement
        case .ones:
            onesComplement
        case .leftShift:
            bitwiseLeftShift
        case .rightShift:
            bitwiseRightShift
        }
    }
    
    private func flipBytes(_ value: UInt) -> UInt {
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
        let cpuRegisterSize = String(UInt.max, radix: 2).count
        let rightShiftCount = cpuRegisterSize - paddedNumberByteCount * 8
        
        // A single byte flipped is itself.
        guard paddedNumberByteCount > 1 else {
            return value
        }
        
        return value.byteSwapped >> rightShiftCount
    }
    
    private func onesComplement(_ value: UInt) -> UInt {
        // The bitwise NOT operator (~) inverts all bits in a number.
        ~value
    }
    
    private func twosComplement(_ value: UInt) -> UInt {
        guard value > 0 else {
            return value
        }
        
        // Check for overflow before performing the operation.
        let onesComplement = onesComplement(value)
        guard UInt.max - onesComplement >= 1 else {
            return value
        }
        
        return onesComplement + 1
    }
    
    private func bitwiseLeftShift(_ value: UInt) -> UInt {
        value << 1
    }
    
    private func bitwiseRightShift(_ value: UInt) -> UInt {
        value >> 1
    }
}
