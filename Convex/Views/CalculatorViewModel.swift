//
//  CalculatorViewModel.swift
//  Convex
//
//  Created by Matt Daigle on 7/1/24.
//

import Foundation

extension CalculatorView {
    
    @Observable
    final class ViewModel {
        
        private let model = CalculatorModel()
        
        var bases: [Base] {
            model.bases
        }
        var selectedBase = Base.hex
        
        private(set) var displayValue: UInt = 0
        
        var numbersRowCount: Int {
            model.numbers.count
        }
        var numbersColumnCount: Int {
            model.numbers.first?.count ?? 0
        }
        
        func isDecimal(value: UInt) -> Bool {
            Base.decimal.values.contains(value)
        }
        
        func isValueEnabled(_ value: UInt) -> Bool {
            selectedBase.values.contains(value)
        }
        
        func valueFor(row: Int, column: Int) -> UInt? {
            guard row < model.numbers.count, column < model.numbers[row].count else {
                return nil
            }
            
            return model.numbers[row][column]
        }
    }
}
