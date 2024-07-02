//
//  View+LayoutChanges.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

// MARK: - Size

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .init()
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {

    func onSizeChange(perform action: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }
}
