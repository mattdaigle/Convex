//
//  OperationButton+ViewModel.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

extension OperationButton {

    final class ViewModel {

        let operation: Operation
        let title: String

        init(operation: Operation) {
            self.operation = operation
            self.title = operation.title
        }
    }
}
