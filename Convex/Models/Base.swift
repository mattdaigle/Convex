//
//  Base.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import Foundation

enum Base: CaseIterable {
    case binary
    case octal
    case decimal
    case hex
    
    var title: String {
        switch self {
        case .binary:
            "bin"
        case .octal:
            "oct"
        case .decimal:
            "dec"
        case .hex:
            "hex"
        }
    }
    
    var values: [UInt] {
        return Array(0..<radixValue)
    }
    
    var radixValue: UInt {
        switch self {
        case .binary:
            2
        case .octal:
            8
        case .decimal:
            10
        case .hex:
            16
        }
    }
}
