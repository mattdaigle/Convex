//
//  DecimalNumberButton.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

struct DecimalNumberButton: View {
    
    @State var viewModel: NumberButtonViewModel
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
        .buttonStyle(NumberButtonStyle(base: .decimal, size: width))
    }
}

#Preview {
    DecimalNumberButton(viewModel: .init(value: 9), action: {})
}
