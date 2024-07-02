//
//  OperationButtonStyle.swift
//  Convex
//
//  Created by Matt Daigle on 7/1/24.
//

import SwiftUI

struct OperationButtonStyle: ButtonStyle {

    let size: Double

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: CGFloat(size / 3), weight: .bold).monospaced())
            .background(Color.Theme.red)
            .foregroundStyle(Color.Theme.foreground)
            .clipShape(Circle())
            .opacity(configuration.isPressed ? 0.3 : 1)
            .padding(6)
    }
}
