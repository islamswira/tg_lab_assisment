//
//  TeamGamesView.swift
//  TGLabNBA
//

import SwiftUI

struct TeamGamesView: View {
    let team: Team
    @Bindable var viewModel: TeamGamesViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading games...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .error(let message):
                VStack(spacing: 16) {
                    Text(message)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await viewModel.retry() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()

            case .loaded:
                gamesList
            }
        }
        .navigationTitle(team.fullName)
        .task {
            if viewModel.state == .idle {
                await viewModel.loadGames(teamId: team.id)
            }
        }
    }

    private var gamesList: some View {
        List {
            // Column header
            HStack(spacing: 8) {
                Text("Home / Visitor").font(.caption).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Score").font(.caption).bold()
                    .frame(width: 40)
                Text("Date").font(.caption).bold()
                    .frame(width: 70)
            }
            .listRowSeparator(.hidden)

            ForEach(viewModel.games) { game in
                GameRowView(game: game)
                    .onAppear {
                        if game.id == viewModel.games.last?.id {
                            Task { await viewModel.loadMore() }
                        }
                    }
            }

            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .accessibilityIdentifier("games_list")
    }
}
