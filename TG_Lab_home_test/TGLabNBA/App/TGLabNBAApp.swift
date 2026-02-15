//
//  TGLabNBAApp.swift
//  TGLabNBA
//

import SwiftUI

@main
struct TGLabNBAApp: App {
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            MainTabView(container: container)
        }
    }
}
