//
//  PlayersSearchViewModelTests.swift
//  TGLabNBATests
//

import XCTest
@testable import TGLabNBA

final class PlayersSearchViewModelTests: XCTestCase {
    private let logger = OSAppLogger(category: "Tests")

    private final class MockPlayersRepo: PlayersRepository {
        var handler: ((String, Int?) async throws -> (players: [Player], nextCursor: Int?))?

        func searchPlayers(query: String, cursor: Int?) async throws -> (players: [Player], nextCursor: Int?) {
            guard let handler else { fatalError("Missing handler") }
            return try await handler(query, cursor)
        }
    }

    private func makePlayer(id: Int, firstName: String, lastName: String) -> Player {
        Player(
            id: id,
            firstName: firstName,
            lastName: lastName,
            position: "G",
            team: Team(id: 1, fullName: "Atlanta Hawks", name: "Hawks", city: "Atlanta", conference: "East", abbreviation: "ATL")
        )
    }

    func test_search_returnsMatchingPlayers() async {
        let repo = MockPlayersRepo()
        repo.handler = { query, _ in
            (players: [self.makePlayer(id: 1, firstName: "Stephen", lastName: "Curry")], nextCursor: nil)
        }

        let useCase = SearchPlayersUseCase(repository: repo, logger: logger)
        let sut = await PlayersSearchViewModel(searchPlayersUseCase: useCase, logger: logger)

        await MainActor.run { sut.searchText = "Curry" }
        await sut.search()

        await MainActor.run {
            XCTAssertEqual(sut.players.count, 1)
            XCTAssertEqual(sut.players.first?.lastName, "Curry")
            XCTAssertEqual(sut.state, .loaded)
        }
    }

    func test_emptySearch_clearsResults() async {
        let repo = MockPlayersRepo()
        repo.handler = { _, _ in
            XCTFail("Should not call repository for empty search")
            return (players: [], nextCursor: nil)
        }

        let useCase = SearchPlayersUseCase(repository: repo, logger: logger)
        let sut = await PlayersSearchViewModel(searchPlayersUseCase: useCase, logger: logger)

        await MainActor.run { sut.searchText = "" }
        await sut.search()

        await MainActor.run {
            XCTAssertTrue(sut.players.isEmpty)
            XCTAssertEqual(sut.state, .idle)
        }
    }

    func test_search_failure_setsError() async {
        let repo = MockPlayersRepo()
        repo.handler = { _, _ in throw NetworkError.invalidResponse }

        let useCase = SearchPlayersUseCase(repository: repo, logger: logger)
        let sut = await PlayersSearchViewModel(searchPlayersUseCase: useCase, logger: logger)

        await MainActor.run { sut.searchText = "test" }
        await sut.search()

        await MainActor.run {
            guard case .error = sut.state else {
                return XCTFail("Expected error state")
            }
        }
    }
}
