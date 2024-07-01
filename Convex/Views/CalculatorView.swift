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
    
    @State private var selectedBase: Base = .hex

    var body: some View {
        ZStack {
            Color.Theme.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                basePicker
                numberButtons
            }
        }
    }
    
    private var basePicker: some View {
        Picker("Base", selection: $selectedBase) {
            ForEach(Base.allCases, id: \.self) { base in
                Text(base.title)
                    .font(.system(.title))
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var numberButtons: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<numbers.count, id: \.self) { row in
                GridRow {
                    ForEach(0..<numbers[row].count, id: \.self) { column in
                        let value = numbers[row][column]
                        let isEnabled = selectedBase.values.contains(value)
                        
                        numberButton(for: value)
                            .disabled(!isEnabled)
                            .opacity(isEnabled ? 1 : 0.1)
                    }
                }
            }
        }
        .padding(6)
    }
    
    @ViewBuilder
    private func numberButton(for value: Int) -> some View {
        let viewModel = NumberButtonViewModel(value: value)
        
        if Base.decimal.values.contains(value) {
            DecimalNumberButton(viewModel: viewModel)
        } else {
            HexNumberButton(viewModel: viewModel)
        }
    }
}

#Preview {
    CalculatorView()
}
