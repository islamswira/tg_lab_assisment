//
//  TeamGamesViewModelTests.swift
//  TGLabNBATests
//

import XCTest
@testable import TGLabNBA

final class TeamGamesViewModelTests: XCTestCase {
    private let logger = OSAppLogger(category: "Tests")

    private final class MockGamesRepo: GamesRepository {
        var handler: ((Int, Int?) async throws -> (games: [Game], nextCursor: Int?))?

        func fetchGames(teamId: Int, cursor: Int?) async throws -> (games: [Game], nextCursor: Int?) {
            guard let handler else { fatalError("Missing handler") }
            return try await handler(teamId, cursor)
        }
    }

    private func makeTeam(id: Int = 1, name: String = "Hawks") -> Team {
        Team(id: id, fullName: "Atlanta \(name)", name: name, city: "Atlanta", conference: "East", abbreviation: "ATL")
    }

    private func makeGame(id: Int, homeScore: Int = 100, visitorScore: Int = 95) -> Game {
        Game(
            id: id,
            date: "2024-10-22",
            homeTeam: makeTeam(),
            homeScore: homeScore,
            visitorTeam: makeTeam(id: 2, name: "Celtics"),
            visitorScore: visitorScore
        )
    }

    func test_loadGames_success_populatesGames() async {
        let repo = MockGamesRepo()
        repo.handler = { _, _ in
            (games: [self.makeGame(id: 1), self.makeGame(id: 2)], nextCursor: 3)
        }

        let useCase = FetchTeamGamesUseCase(repository: repo, logger: logger)
        let sut = await TeamGamesViewModel(fetchGamesUseCase: useCase, logger: logger)

        await sut.loadGames(teamId: 1)

        await MainActor.run {
            XCTAssertEqual(sut.games.count, 2)
            XCTAssertEqual(sut.state, .loaded)
            XCTAssertTrue(sut.hasMore)
        }
    }

    func test_loadMore_appendsGamesAndUpdatesCursor() async {
        let repo = MockGamesRepo()
        var callCount = 0
        repo.handler = { _, cursor in
            callCount += 1
            if cursor == nil {
                return (games: [self.makeGame(id: 1)], nextCursor: 2)
            } else {
                return (games: [self.makeGame(id: 2)], nextCursor: nil)
            }
        }

        let useCase = FetchTeamGamesUseCase(repository: repo, logger: logger)
        let sut = await TeamGamesViewModel(fetchGamesUseCase: useCase, logger: logger)

        await sut.loadGames(teamId: 1)
        await sut.loadMore()

        await MainActor.run {
            XCTAssertEqual(sut.games.count, 2)
            XCTAssertFalse(sut.hasMore)
            XCTAssertEqual(callCount, 2)
        }
    }

    func test_loadGames_failure_setsError() async {
        let repo = MockGamesRepo()
        repo.handler = { _, _ in throw NetworkError.invalidResponse }

        let useCase = FetchTeamGamesUseCase(repository: repo, logger: logger)
        let sut = await TeamGamesViewModel(fetchGamesUseCase: useCase, logger: logger)

        await sut.loadGames(teamId: 1)

        await MainActor.run {
            guard case .error = sut.state else {
                return XCTFail("Expected error state")
            }
        }
    }

    func test_noMorePages_hasMoreIsFalse() async {
        let repo = MockGamesRepo()
        repo.handler = { _, _ in
            (games: [self.makeGame(id: 1)], nextCursor: nil)
        }

        let useCase = FetchTeamGamesUseCase(repository: repo, logger: logger)
        let sut = await TeamGamesViewModel(fetchGamesUseCase: useCase, logger: logger)

        await sut.loadGames(teamId: 1)

        await MainActor.run {
            XCTAssertFalse(sut.hasMore)
        }
    }
}
