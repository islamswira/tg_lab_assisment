//
//  TeamGamesViewModel.swift
//  TGLabNBA
//

import Foundation
import Observation

@Observable
final class TeamGamesViewModel {
    private let fetchGamesUseCase: FetchTeamGamesUseCase
    private let logger: AppLogging

    private var teamId: Int = 0
    private var nextCursor: Int?

    var games: [Game] = []
    var state: ViewState = .idle
    var isLoadingMore: Bool = false

    var hasMore: Bool { nextCursor != nil }

    init(fetchGamesUseCase: FetchTeamGamesUseCase, logger: AppLogging) {
        self.fetchGamesUseCase = fetchGamesUseCase
        self.logger = logger
    }

    @MainActor
    func loadGames(teamId: Int) async {
        self.teamId = teamId
        state = .loading
        games = []
        nextCursor = nil

        do {
            let result = try await fetchGamesUseCase.execute(teamId: teamId, cursor: nil)
            games = result.games
            nextCursor = result.nextCursor
            state = .loaded
        } catch {
            logger.error("loadGames failed: \(error)")
            state = .error("Couldn't load games.")
        }
    }

    @MainActor
    func loadMore() async {
        guard hasMore, !isLoadingMore else { return }
        isLoadingMore = true

        do {
            let result = try await fetchGamesUseCase.execute(teamId: teamId, cursor: nextCursor)
            games.append(contentsOf: result.games)
            nextCursor = result.nextCursor
        } catch {
            logger.error("loadMore failed: \(error)")
        }

        isLoadingMore = false
    }

    @MainActor
    func retry() async {
        await loadGames(teamId: teamId)
    }
}
