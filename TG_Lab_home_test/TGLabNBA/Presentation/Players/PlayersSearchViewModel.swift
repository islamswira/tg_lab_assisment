//
//  PlayersSearchViewModel.swift
//  TGLabNBA
//

import Foundation
import Observation

@Observable
final class PlayersSearchViewModel {
    private let searchPlayersUseCase: SearchPlayersUseCase
    private let logger: AppLogging

    var players: [Player] = []
    var searchText: String = ""
    var state: ViewState = .idle

    init(searchPlayersUseCase: SearchPlayersUseCase, logger: AppLogging) {
        self.searchPlayersUseCase = searchPlayersUseCase
        self.logger = logger
    }

    @MainActor
    func search() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            players = []
            state = .idle
            return
        }

        state = .loading

        do {
            let result = try await searchPlayersUseCase.execute(query: query)
            players = result.players
            state = .loaded
        } catch is CancellationError {
            // Debounce cancellation — expected, do nothing
        } catch {
            logger.error("Player search failed: \(error)")
            state = .error("Search failed, try again.")
        }
    }
}
