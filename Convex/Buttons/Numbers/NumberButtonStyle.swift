//
//  NumberButtonStyle.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

struct NumberButtonStyle: ButtonStyle {
    
    let base: Base
    let size: Double
    
    private var backgroundColor: Color {
        switch base {
        case .hex:
            .Theme.currentLine
        default:
            .Theme.background
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: CGFloat(size / 2)).monospaced())
            .background(backgroundColor)
            .foregroundStyle(Color.Theme.foreground)
            .clipShape(Circle())
            .opacity(configuration.isPressed ? 0.3 : 1)
            .padding(6)
    }
}
