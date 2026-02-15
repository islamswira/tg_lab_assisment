//
//  TeamsListViewModelTests.swift
//  TGLabNBATests
//

import XCTest
@testable import TGLabNBA

final class TeamsListViewModelTests: XCTestCase {
    private let logger = OSAppLogger(category: "Tests")

    func test_fetchTeams_success_populatesListAndSetsLoaded() async {
        let repo = MockTeamsRepo()
        repo.handler = {
            [
                Team(id: 1, fullName: "Atlanta Hawks", name: "Hawks", city: "Atlanta", conference: "East", abbreviation: "ATL"),
                Team(id: 2, fullName: "Boston Celtics", name: "Celtics", city: "Boston", conference: "East", abbreviation: "BOS")
            ]
        }

        let useCase = FetchTeamsUseCase(repository: repo, logger: logger)
        let sut = await TeamsListViewModel(fetchTeamsUseCase: useCase, logger: logger)

        await sut.fetchTeams()

        await MainActor.run {
            XCTAssertEqual(sut.teams.count, 2)
            XCTAssertEqual(sut.state, .loaded)
            // Default sort is by name
            XCTAssertEqual(sut.teams.first?.fullName, "Atlanta Hawks")
        }
    }

    func test_fetchTeams_failure_setsError() async {
        let repo = MockTeamsRepo()
        repo.handler = { throw NetworkError.invalidResponse }

        let useCase = FetchTeamsUseCase(repository: repo, logger: logger)
        let sut = await TeamsListViewModel(fetchTeamsUseCase: useCase, logger: logger)

        await sut.fetchTeams()

        await MainActor.run {
            guard case .error = sut.state else {
                return XCTFail("Expected error state")
            }
            XCTAssertTrue(sut.teams.isEmpty)
        }
    }

    func test_sortByCity_reordersCorrectly() async {
        let repo = MockTeamsRepo()
        repo.handler = {
            [
                Team(id: 1, fullName: "Boston Celtics", name: "Celtics", city: "Boston", conference: "East", abbreviation: "BOS"),
                Team(id: 2, fullName: "Atlanta Hawks", name: "Hawks", city: "Atlanta", conference: "East", abbreviation: "ATL")
            ]
        }

        let useCase = FetchTeamsUseCase(repository: repo, logger: logger)
        let sut = await TeamsListViewModel(fetchTeamsUseCase: useCase, logger: logger)

        await sut.fetchTeams()
        await sut.updateSortOrder(.city)

        await MainActor.run {
            XCTAssertEqual(sut.sortOrder, .city)
            XCTAssertEqual(sut.teams.first?.city, "Atlanta")
            XCTAssertEqual(sut.teams.last?.city, "Boston")
        }
    }

    func test_sortByConference_reordersCorrectly() async {
        let repo = MockTeamsRepo()
        repo.handler = {
            [
                Team(id: 1, fullName: "Los Angeles Lakers", name: "Lakers", city: "Los Angeles", conference: "West", abbreviation: "LAL"),
                Team(id: 2, fullName: "Atlanta Hawks", name: "Hawks", city: "Atlanta", conference: "East", abbreviation: "ATL")
            ]
        }

        let useCase = FetchTeamsUseCase(repository: repo, logger: logger)
        let sut = await TeamsListViewModel(fetchTeamsUseCase: useCase, logger: logger)

        await sut.fetchTeams()
        await sut.updateSortOrder(.conference)

        await MainActor.run {
            XCTAssertEqual(sut.teams.first?.conference, "East")
            XCTAssertEqual(sut.teams.last?.conference, "West")
        }
    }
}
