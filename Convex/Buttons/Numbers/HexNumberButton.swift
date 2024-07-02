//
//  HexNumberButton.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

struct HexNumberButton: View {

    var viewModel: NumberButtonViewModel
    @State private var width: CGFloat = .zero
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(viewModel.title)
                .frame(maxWidth: .infinity)
                .frame(height: width)
                .onSizeChange { size in
                    width = size.width
                }
        }
        .buttonStyle(NumberButtonStyle(base: .hex, size: width))
    }
}

#Preview {
    HexNumberButton(viewModel: .init(value: 0xA), action: {})
}
