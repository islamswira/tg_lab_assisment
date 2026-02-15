//
//  TeamsListViewModel.swift
//  TGLabNBA
//

import Foundation
import Observation

@Observable
final class TeamsListViewModel {
    private let fetchTeamsUseCase: FetchTeamsUseCase
    private let logger: AppLogging

    private var allTeams: [Team] = []

    var teams: [Team] = []
    var state: ViewState = .idle
    var sortOrder: SortOrder = .name

    init(fetchTeamsUseCase: FetchTeamsUseCase, logger: AppLogging) {
        self.fetchTeamsUseCase = fetchTeamsUseCase
        self.logger = logger
    }

    @MainActor
    func fetchTeams() async {
        guard state != .loading else { return }
        state = .loading

        do {
            allTeams = try await fetchTeamsUseCase.execute()
            applySortOrder()
            state = .loaded
        } catch {
            logger.error("fetchTeams: \(error)")
            state = .error("Couldn't load teams.")
        }
    }

    @MainActor
    func updateSortOrder(_ order: SortOrder) {
        sortOrder = order
        applySortOrder()
    }

    @MainActor
    private func applySortOrder() {
        switch sortOrder {
        case .name:
            teams = allTeams.sorted { $0.fullName < $1.fullName }
        case .city:
            teams = allTeams.sorted { $0.city < $1.city }
        case .conference:
            teams = allTeams.sorted { $0.conference < $1.conference }
        }
    }

    @MainActor
    func retry() async {
        await fetchTeams()
    }
}
