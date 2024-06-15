//
//  ShimmerGenApp.swift
//  ShimmerGen
//
//  Created by Jamie Chu on 6/14/24.
//

import SwiftUI

@main
struct ShimmerGenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
    }
}
