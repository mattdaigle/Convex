//
//  CalculatorModel.swift
//  Convex
//
//  Created by Matthew Daigle on 8/4/15.
//  Copyright (c) 2015 Matt Daigle. All rights reserved.
//

import Foundation

let radixValue: [String:UInt] = ["bin":2, "oct":8, "dec":10, "hex":16]

class CalculatorModel: NSObject {
	
	let cpuRegisterSize = String(UInt.max, radix: 2).characters.count
	
	func flipBytes(value: UInt) -> UInt {
		var value = value
		if value > 0 {
			// Determine how many bytes the number is.
			let zero: Character = "0"
			let currentNumberAsBinary = String(value, radix: 2)
			let currentNumberBitCount = currentNumberAsBinary.characters.count
			var bitPaddingCount = 8 - currentNumberBitCount % 8
			if bitPaddingCount == 8 {
				bitPaddingCount = 0
			}
			let bitPadding = String(repeating: String(zero), count: bitPaddingCount)
			let paddedNumberAsBinary = bitPadding + currentNumberAsBinary
			let paddedNumberByteCount = UInt(paddedNumberAsBinary.characters.count/8)
			let rightShiftCount = UInt(cpuRegisterSize) - UInt(paddedNumberByteCount * 8)
			
			if(paddedNumberByteCount > 1) {
				value = value.byteSwapped >> rightShiftCount
			}
		}
		
		return value
	}
	
	func twosComplement(value: UInt) -> UInt {
		var value = value
		if value > 0 {
            let overflowValue = UInt.max - ~value
			if overflowValue >= 1 {
				// We won't overflow. Complete the two's complement.
				value = ~value + 1
			}
		}
		
		return value
	}
	
	func appendDigit(value: UInt, digit: String, type: String) -> UInt {
		var value = value
		if value > 0 || digit != "0" {
			let numberToAppendAsUInt = strtoul(digit, nil, 16)
			let radix = radixValue[type]!
			
			if value == 0 {
				value = value * radix + numberToAppendAsUInt
			} else if UInt.max / value >= radix {
				if UInt.max - value * radix >= numberToAppendAsUInt {
					// We won't overflow.
					value = value * radix + numberToAppendAsUInt
				}
			}
		}
		
		return value
	}
}
