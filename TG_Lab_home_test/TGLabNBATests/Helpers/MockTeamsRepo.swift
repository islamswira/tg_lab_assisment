//
//  MockTeamsRepo.swift
//  TGLabNBATests
//

import Foundation
@testable import TGLabNBA

final class MockTeamsRepo: TeamsRepository {
    var handler: (() async throws -> [Team])?

    func fetchTeams() async throws -> [Team] {
        guard let handler else { fatalError("Missing handler") }
        return try await handler()
    }
}
