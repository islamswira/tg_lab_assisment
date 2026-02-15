//
//  NBAAppUITests.swift
//  TGLabNBAUITests
//

import XCTest

final class NBAAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    func test_homeTab_showsTeamsList() {
        let teamsList = app.collectionViews["teams_list"]
        XCTAssertTrue(teamsList.waitForExistence(timeout: 5))
    }

    func test_homeTab_sortButton_exists() {
        let sortButton = app.buttons["sort_button"]
        XCTAssertTrue(sortButton.waitForExistence(timeout: 5))
    }

    func test_homeTab_sortButton_showsSheet() {
        let sortButton = app.buttons["sort_button"]
        XCTAssertTrue(sortButton.waitForExistence(timeout: 5))
        sortButton.tap()

        let cityOption = app.buttons["sort_option_City"]
        XCTAssertTrue(cityOption.waitForExistence(timeout: 3))
    }

    func test_playersTab_exists() {
        app.tabBars.buttons["Players"].tap()
        let searchField = app.searchFields["Search"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
    }
}
