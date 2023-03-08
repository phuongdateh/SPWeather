//
//  SPWeatherUITests.swift
//  SPWeatherUITests
//
//  Created by James on 08/03/2023.
//

import XCTest

final class SPWeatherUITests: XCTestCase {
    override func setUp() {
        XCUIApplication().launch()
    }

    func testHomeViewControllerSearchThenNavigateToDetailScreen() {
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars.element(boundBy: 0).staticTexts.element.label, "Home")
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .searchField).element.tap()
        
        app.keys["p"].tap()
        app.keys["a"].tap()
        app.keys["r"].tap()
        app.keys["i"].tap()
        app.keys["s"].tap()
        XCTAssert(app.searchFields.element.waitForExistence(timeout: 2))
        
        let tablesQuery = app.tables
        let lastCityTaped: String = tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts.element.label
        tablesQuery.children(matching: .cell).element(boundBy: 0).tap()
        
        let homeButton = app.navigationBars["Weather Detail"].buttons["Home"]
        XCTAssertEqual(app.navigationBars.element(boundBy: 0).staticTexts.element.label, "Weather Detail")
        homeButton.tap()
        
        app.staticTexts["Cancel"].tap()
        let firstCityHistory: String = tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts.element.label
        XCTAssertEqual(firstCityHistory, lastCityTaped)

        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()
        homeButton.tap()
    }
}
