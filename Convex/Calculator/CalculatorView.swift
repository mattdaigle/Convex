//
//  CalculatorView.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

struct CalculatorView: View {

    @State private var viewModel = ViewModel()
    @State private var numberFontSize: CGFloat = .zero
    private let pasteboardChangedPublisher = NotificationCenter.default.publisher(for: UIPasteboard.changedNotification)
    @State private var canPaste = false

    var body: some View {
        ZStack {
            Color.Theme.black
                .ignoresSafeArea()

            VStack(alignment: .trailing, spacing: 10) {
                numberView
                basePicker
                buttons
            }
        }
        .preferredColorScheme(.dark)
        .onReceive(pasteboardChangedPublisher) { _ in
            canPaste = viewModel.canPaste
        }
    }

    @ViewBuilder
    private var numberView: some View {
        Menu {
            Button {
                viewModel.copy()
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }

            if canPaste {
                Button {
                    viewModel.paste()
                } label: {
                    Label("Paste", systemImage: "doc.on.clipboard")
                }
            }

            Button(role: .destructive) {
                viewModel.clear()
            } label: {
                Label("Clear", systemImage: "clear")
            }
        } label: {
            Group {
                if viewModel.selectedBase == .binary {
                    binaryNumber
                } else {
                    Text(viewModel.displayValue)
                }
            }
            .lineLimit(1)
            .foregroundStyle(Color.Theme.foreground)
            .multilineTextAlignment(.trailing)
            .font(.system(size: 100, weight: .light)).monospaced()
            .minimumScaleFactor(0.01)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.horizontal, 12)
            .padding(.bottom, 30)
        }
        .gesture(
            DragGesture()
                .onEnded { _ in
                    viewModel.backspace()
                }
        )
    }

    private var binaryNumber: some View {
        VStack(spacing: 30) {
            let binaryStrings = viewModel.displayValue.split(separator: "\n").map { String($0) }
            ForEach(Array(binaryStrings.enumerated()), id: \.offset) { index, binaryString in
                VStack {
                    Text(binaryString)
                    HStack {
                        let leadingPlace = (binaryStrings.count - index) * 32 - 1
                        Text("\(leadingPlace)")
                            .padding(.leading, 1)
                        Spacer()
                        let centerPlace = leadingPlace - 16
                        Text("\(centerPlace)")
                            .padding(.leading, centerPlace == 15 ? 14 : 16)
                        Spacer()
                        let trailingPlace = centerPlace - 15
                        Text("\(trailingPlace)")
                            .padding(.trailing, trailingPlace == 0 ? 3 : 1)
                    }
                    .foregroundStyle(Color.Theme.cyan)
                    .font(.system(size: 11, weight: .bold)).monospaced()
                }
            }
        }
    }

    private var basePicker: some View {
        Picker("Base", selection: $viewModel.selectedBase) {
            ForEach(viewModel.bases, id: \.self) { Text($0.title) }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 12)
    }

    private var buttons: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            // Operators.
            GridRow {
                ForEach(viewModel.operations, id: \.self) { operation in
                    let action: () -> Void = {
                        viewModel.perform(operation)
                    }
                    OperationButton(viewModel: .init(operation: operation), action: action)
                }
            }

            // Numbers.
            ForEach(0..<viewModel.numbersRowCount, id: \.self) { row in
                GridRow {
                    ForEach(0..<viewModel.numbersColumnCount, id: \.self) { column in
                        if let value = viewModel.numberFor(row: row, column: column) {
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
        let action = {
            viewModel.append(value)
        }

        if viewModel.isDecimal(value: value) {
            DecimalNumberButton(viewModel: .init(value: value), action: action)
        } else {
            HexNumberButton(viewModel: .init(value: value), action: action)
        }
    }
}

#Preview {
    CalculatorView()
}
