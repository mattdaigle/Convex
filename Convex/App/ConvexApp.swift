//
//  ConvexApp.swift
//  Convex
//
//  Created by Matt Daigle on 6/30/24.
//

import SwiftUI

@main
struct ConvexApp: App {
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .Theme.foreground
        UISegmentedControl.appearance().backgroundColor = .Theme.background
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.Theme.currentLine)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.Theme.foreground)], for: .normal)
    }
    
    var body: some Scene {
        WindowGroup {
            CalculatorView()
        }
    }
}
