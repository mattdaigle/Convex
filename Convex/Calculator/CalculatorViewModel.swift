//
//  CalculatorViewModel.swift
//  Convex
//
//  Created by Matt Daigle on 7/1/24.
//

import SwiftUI

extension CalculatorView {
    
    @Observable
    final class ViewModel {
        
        private let model = CalculatorModel()
        var displayValue: String {
            switch selectedBase {
            case .binary:
                // Convert to binary and pad with zeroes.
                let binaryString = String(model.currentValue, radix: 2)
                let cpuRegisterSize = String(UInt.max, radix: 2).count
                let zeroPadding = (0..<cpuRegisterSize - binaryString.count).map { _ in "0" }
                let paddedBinaryString = zeroPadding.joined() + binaryString
                let groupSize = 4
                
                let formattedString: String
                if cpuRegisterSize == 32 {
                    formattedString = paddedBinaryString.groupedBy(groupSize)
                } else {
                    // Split the bits in half.
                    let midpoint = paddedBinaryString.index(paddedBinaryString.startIndex, offsetBy: paddedBinaryString.count/2)
                    let upperString = String(paddedBinaryString[paddedBinaryString.startIndex..<midpoint])
                    let lowerString = String(paddedBinaryString[midpoint..<paddedBinaryString.endIndex])
                    formattedString = upperString.groupedBy(groupSize) + "\n" + lowerString.groupedBy(groupSize)
                }
                
                return formattedString
            case .octal:
                return selectedBase.prefix + String(model.currentValue, radix: selectedBase.radix)
            case .decimal:
                let noCommaString = String(model.currentValue, radix: selectedBase.radix)
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                
                return formatter.string(from: NSNumber(value: model.currentValue)) ?? noCommaString
            case .hex:
                return selectedBase.prefix + String(model.currentValue, radix: selectedBase.radix, uppercase: true)
            }
        }
        
        var selectedBase: Base = .hex {
            didSet {
                model.updateBaseValue(to: selectedBase)
            }
        }
        
        var bases: [Base] {
            model.bases
        }
        
        var operations: [Operations] {
            model.operations
        }
        
        var numbersRowCount: Int {
            model.numbers.count
        }
        
        var numbersColumnCount: Int {
            model.numbers.first?.count ?? 0
        }
        
        private var pasteboardValue: UInt? {
            guard let pasteboardString = UIPasteboard.general.string, let base = Base(string: pasteboardString) else {
                return nil
            }
            
            return UInt(pasteboardString.trimmingPrefix(base.prefix), radix: base.radix)
        }
        
        var canPaste: Bool {
            pasteboardValue != nil
        }
        
        func isDecimal(value: UInt) -> Bool {
            Base.decimal.values.contains(value)
        }
        
        func isValueEnabled(_ value: UInt) -> Bool {
            selectedBase.values.contains(value)
        }
        
        func numberFor(row: Int, column: Int) -> UInt? {
            guard row < model.numbers.count, column < model.numbers[row].count else {
                return nil
            }
            
            return model.numbers[row][column]
        }
        
        func append(_ digit: UInt) {
            model.append(digit)
        }
        
        func backspace() {
            model.removeLeastSignificantDigit()
        }
        
        func copy() {
            let currentBase = model.currentBase
            UIPasteboard.general.string = currentBase.prefix + String(model.currentValue, radix: currentBase.radix)
        }
        
        func paste() {
            if let pasteboardValue {
                model.paste(value: pasteboardValue)
            }
        }
        
        func clear() {
            model.clear()
        }
        
        func perform(_ operation: Operations) {
            model.perform(operation)
        }
    }
}
