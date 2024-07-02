//
//  OperationButton.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

struct OperationButton: View {
    
    @State var viewModel: ViewModel
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
        .buttonStyle(OperationButtonStyle(size: width))
    }
}

#Preview {
    OperationButton(viewModel: .init(operation: .flip), action: {})
}
