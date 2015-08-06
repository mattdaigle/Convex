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
	
	let cpuRegisterSize = count(String(UInt.max, radix: 2))
	
	func flipBytes(var value: UInt) -> UInt {
		if value > 0 {
			// Determine how many bytes the number is.
			let zero: Character = "0"
			let currentNumberAsBinary = String(value, radix: 2)
			let currentNumberBitCount = count(currentNumberAsBinary)
			var bitPaddingCount = 8 - currentNumberBitCount % 8
			if bitPaddingCount == 8 {
				bitPaddingCount = 0
			}
			let bitPadding = String(count: bitPaddingCount, repeatedValue: zero)
			let paddedNumberAsBinary = bitPadding + currentNumberAsBinary
			let paddedNumberByteCount = UInt(count(paddedNumberAsBinary)/8)
			var rightShiftCount = UInt(cpuRegisterSize) - UInt(paddedNumberByteCount * 8)
			
			if(paddedNumberByteCount > 1) {
				value = value.byteSwapped >> rightShiftCount
			}
		}
		
		return value
	}
	
	func twosComplement(var value: UInt) -> UInt {
		if value > 0 {
			if UInt.max - ~value >= 1 {
				// We won't overflow. Complete the two's complement.
				value = ~value + 1
			}
		}
		
		return value
	}
	
	func appendDigit(var value: UInt, digit: String, type: String) -> UInt {
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