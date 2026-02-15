//
//  FetchTeamsUseCaseTests.swift
//  TGLabNBATests
//

import XCTest
@testable import TGLabNBA

final class FetchTeamsUseCaseTests: XCTestCase {
    private let logger = OSAppLogger(category: "Tests")

    func test_execute_success_returnsTeams() async throws {
        let repo = MockTeamsRepo()
        let expectedTeams = [
            Team(id: 1, fullName: "Atlanta Hawks", name: "Hawks", city: "Atlanta", conference: "East", abbreviation: "ATL")
        ]
        repo.handler = { expectedTeams }

        let sut = FetchTeamsUseCase(repository: repo, logger: logger)
        let result = try await sut.execute()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, 1)
    }

    func test_execute_failure_propagatesError() async {
        let repo = MockTeamsRepo()
        repo.handler = { throw NetworkError.invalidResponse }

        let sut = FetchTeamsUseCase(repository: repo, logger: logger)

        do {
            _ = try await sut.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
