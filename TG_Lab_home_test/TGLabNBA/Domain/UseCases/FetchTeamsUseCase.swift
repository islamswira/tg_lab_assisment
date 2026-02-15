//
//  FetchTeamsUseCase.swift
//  TGLabNBA
//

import Foundation

struct FetchTeamsUseCase {
    private let repository: TeamsRepository
    private let logger: AppLogging

    init(repository: TeamsRepository, logger: AppLogging) {
        self.repository = repository
        self.logger = logger
    }

    func execute() async throws -> [Team] {
        let teams = try await repository.fetchTeams()
        logger.info("Fetched \(teams.count) teams")
        return teams
    }
}
