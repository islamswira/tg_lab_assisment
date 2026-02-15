//
//  PlayersSearchView.swift
//  TGLabNBA
//

import SwiftUI

struct PlayersSearchView: View {
    @Bindable var viewModel: PlayersSearchViewModel
    let container: AppContainer

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    ContentUnavailableView(
                        "Search Players",
                        systemImage: "magnifyingglass",
                        description: Text("Type a player name to search")
                    )

                case .loading:
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .error(let message):
                    VStack(spacing: 16) {
                        Text(message)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.search() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()

                case .loaded:
                    if viewModel.players.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchText)
                    } else {
                        playersList
                    }
                }
            }
            .navigationTitle("Players")
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .task(id: viewModel.searchText) {
                // debounce
                do { try await Task.sleep(for: .milliseconds(400)) } catch { return }
                await viewModel.search()
            }
        }
    }

    private var playersList: some View {
        List {
            // Column header
            HStack(spacing: 12) {
                Spacer().frame(width: 32)
                Text("First Name").font(.caption).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Last Name").font(.caption).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Team").font(.caption).bold()
                    .frame(width: 100, alignment: .trailing)
            }
            .listRowSeparator(.hidden)

            ForEach(viewModel.players) { player in
                NavigationLink(value: player.team) {
                    PlayerRowView(player: player)
                }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Team.self) { team in
            let gamesVM = container.makeTeamGamesViewModel()
            TeamGamesView(team: team, viewModel: gamesVM)
        }
        .accessibilityIdentifier("players_list")
    }
}
