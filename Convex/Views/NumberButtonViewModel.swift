//
//  NumberButtonViewModel.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

@Observable
class NumberButtonViewModel {
    
    let value: Int
    let title: String

    init(value: Int) {
        self.value = value
        self.title = String(format:"%X", value)
    }
}
