//
//  CalculatorView.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

struct CalculatorView: View {

    @State private var viewModel = ViewModel()

    var body: some View {
        ZStack {
            Color.Theme.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                nonBinaryLabel
                basePicker
                numberButtons
            }
        }
    }
    
    private var nonBinaryLabel: some View {
        Text("")
    }
    
    private var basePicker: some View {
        Picker("Base", selection: $viewModel.selectedBase) {
            ForEach(viewModel.bases, id: \.self) { Text($0.title) }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var numberButtons: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<viewModel.numbersRowCount, id: \.self) { row in
                GridRow {
                    ForEach(0..<viewModel.numbersColumnCount, id: \.self) { column in
                        if let value = viewModel.valueFor(row: row, column: column) {
                            let isEnabled = viewModel.isValueEnabled(value)
                            numberButton(for: value)
                                .disabled(!isEnabled)
                                .opacity(isEnabled ? 1 : 0.1)
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .padding(6)
    }
    
    @ViewBuilder
    private func numberButton(for value: UInt) -> some View {
        if viewModel.isDecimal(value: value) {
            DecimalNumberButton(viewModel: .init(value: value))
        } else {
            HexNumberButton(viewModel: .init(value: value))
        }
    }
}

#Preview {
    CalculatorView()
}
