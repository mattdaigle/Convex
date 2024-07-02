//
//  NumberButtonViewModel.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

final class NumberButtonViewModel {

    let value: UInt
    let title: String

    init(value: UInt) {
        self.value = value
        self.title = String(format:"%X", value)
    }
}
