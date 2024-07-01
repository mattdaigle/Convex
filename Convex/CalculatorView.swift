//
//  CalculatorView.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

struct CalculatorView: View {
    private let numbers = [
        [7, 8,   9,   0xF],
        [4, 5,   6,   0xE],
        [1, 2,   3,   0xD],
        [0, 0xA, 0xB, 0xC]
    ]
    
    var body: some View {
        ZStack {
            Color.Theme.black
                .ignoresSafeArea()
            
            VStack {
                Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                    ForEach(0..<numbers.count, id: \.self) { row in
                        GridRow {
                            ForEach(0..<numbers[row].count, id: \.self) { column in
                                numberButton(for: numbers[row][column])
                            }
                        }
                    }
                }
                .padding(6)
            }
        }
    }
    
    @ViewBuilder private func numberButton(for value: Int) -> some View {
        let viewModel = NumberButtonViewModel(value: value)
        
        if value < 10 {
            DecimalNumberButton(viewModel: viewModel)
        } else {
            HexNumberButton(viewModel: viewModel)
        }
    }
}

#Preview {
    CalculatorView()
}
