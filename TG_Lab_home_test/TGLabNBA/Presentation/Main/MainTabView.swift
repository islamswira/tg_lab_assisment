//
//  MainTabView.swift
//  TGLabNBA
//

import SwiftUI

struct MainTabView: View {
    let container: AppContainer

    var body: some View {
        TabView {
            TeamsListView(viewModel: container.teamsViewModel, container: container)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            PlayersSearchView(viewModel: container.playersViewModel, container: container)
                .tabItem {
                    Label("Players", systemImage: "person.3")
                }
        }
    }
}
