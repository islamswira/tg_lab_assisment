//
//  SearchPlayersUseCase.swift
//  TGLabNBA
//

import Foundation

struct SearchPlayersUseCase {
    private let repository: PlayersRepository
    private let logger: AppLogging

    init(repository: PlayersRepository, logger: AppLogging) {
        self.repository = repository
        self.logger = logger
    }

    func execute(query: String, cursor: Int? = nil) async throws -> (players: [Player], nextCursor: Int?) {
        try await repository.searchPlayers(query: query, cursor: cursor)
    }
}
