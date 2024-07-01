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
    
    var values: [Int] {
        switch self {
        case .binary:
            [0, 1]
        case .octal:
            [0, 1, 2, 3, 4, 5, 6, 7]
        case .decimal:
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        case .hex:
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF]
        }
    }
}
