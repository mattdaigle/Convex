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

    init?(string: String) {
        for base in Base.allCases {
            if base == .decimal {
                if UInt(string, radix: base.radix) != nil {
                    self = base
                    return
                } else {
                    continue
                }
            } else if string.hasPrefix(base.prefix) {
                self = base
                return
            }
        }

        return nil
    }

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
        return Array(0..<UInt(radix))
    }

    var radix: Int {
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

    var prefix: String {
        switch self {
        case .binary:
            "0b"
        case .octal:
            "0o"
        case .decimal:
            ""
        case .hex:
            "0x"
        }
    }

    static func radix(forPrefix prefix: String) -> Int {
        let base = allCases.first(where: { $0.prefix == prefix }) ?? .decimal
        return base.radix
    }
}
