//
//  TeamsListView.swift
//  TGLabNBA
//

import SwiftUI

struct TeamsListView: View {
    @Bindable var viewModel: TeamsListViewModel
    let container: AppContainer

    @State private var showingSortSheet = false

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading teams...")
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
                    teamsList
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(viewModel.sortOrder.displayTitle) {
                        showingSortSheet = true
                    }
                    .accessibilityIdentifier("sort_button")
                }
            }
            .sheet(isPresented: $showingSortSheet) {
                SortOrderSheet(selectedOrder: Binding(
                    get: { viewModel.sortOrder },
                    set: { viewModel.updateSortOrder($0) }
                ))
            }
            .task {
                if viewModel.state == .idle {
                    await viewModel.fetchTeams()
                }
            }
        }
    }

    private var teamsList: some View {
        List {
            // Column header
            HStack(spacing: 12) {
                Spacer().frame(width: 36)
                Text("Name").font(.caption).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("City").font(.caption).bold()
                    .frame(width: 90, alignment: .leading)
                Text("Conf").font(.caption).bold()
                    .frame(width: 60)
            }
            .listRowSeparator(.hidden)

            ForEach(viewModel.teams) { team in
                NavigationLink(value: team) {
                    TeamRowView(team: team)
                }
                .accessibilityIdentifier("team_cell_\(team.id)")
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Team.self) { team in
            let gamesVM = container.makeTeamGamesViewModel()
            TeamGamesView(team: team, viewModel: gamesVM)
        }
        .accessibilityIdentifier("teams_list")
    }
}
