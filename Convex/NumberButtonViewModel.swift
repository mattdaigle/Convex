//
//  NumberButtonViewModel.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

@Observable
class NumberButtonViewModel {
    enum Style {
        case decimal
        case hex
    }
    
    let value: Int
    let text: String

    init(value: Int) {
        self.value = value
        self.text = String(format:"%X", value)
    }
}
