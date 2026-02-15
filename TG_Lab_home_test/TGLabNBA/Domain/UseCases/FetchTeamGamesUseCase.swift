//
//  FetchTeamGamesUseCase.swift
//  TGLabNBA
//

import Foundation

struct FetchTeamGamesUseCase {
    private let repository: GamesRepository
    private let logger: AppLogging

    init(repository: GamesRepository, logger: AppLogging) {
        self.repository = repository
        self.logger = logger
    }

    func execute(teamId: Int, cursor: Int?) async throws -> (games: [Game], nextCursor: Int?) {
        try await repository.fetchGames(teamId: teamId, cursor: cursor)
    }
}
