//
//  String+Formatting.swift
//  Convex
//
//  Created by Matt Daigle on 7/1/24.
//

import Foundation

extension String {

    func groupedBy(_ groupSize: Int, separator: Character = " ") -> String {
        let characterArray = enumerated().flatMap { index, value in
            if index > 0 && index % groupSize == 0 {
                return [separator, value]
            } else {
                return [value]
            }
        }

        return String(characterArray)
    }
}
