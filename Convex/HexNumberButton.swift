//
//  HexNumberButton.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

struct HexNumberButton: View {
    
    @State var viewModel: NumberButtonViewModel
    
    var body: some View {
        GeometryReader { geometry in
            Button {
                print("\(viewModel.value) button pressed")
            } label: {
                Text(viewModel.text)
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.width)
            }
            .buttonStyle(NumberButtonStyle(base: .hex, size: geometry.size.width))
        }
    }
}

#Preview {
    HexNumberButton(viewModel: .init(value: 0xA))
}
