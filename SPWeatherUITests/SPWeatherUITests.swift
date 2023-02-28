//
//  SPWeatherUITests.swift
//  SPWeatherUITests
//
//  Created by James on 28/02/2023.
//

import XCTest

class SPWeatherUITests: XCTestCase {
    
    override func setUp() {
        XCUIApplication().launch()
    }
    
    func testSearchCorrectCityName() {
        let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .searchField).element.tap()
                
        app.searchFields.element.typeText("Paris")
        let tablesQuery = app.tables
        XCTAssertEqual(app.navigationBars.element(boundBy: 0).staticTexts.element.label, "Home")
        
        tablesQuery.staticTexts["Paris, France"].tap()
        XCTAssertEqual(tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts.element.label, "Paris, France")
        XCTAssertEqual(tablesQuery.children(matching: .cell).element(boundBy: 1).staticTexts.element.label, "Paris, United States of America")
        XCTAssertEqual(tablesQuery.children(matching: .cell).element(boundBy: 3).staticTexts.element.label, "Paris, United States of America")
        XCTAssertEqual(app.navigationBars.element(boundBy: 0).staticTexts.element.label, "Weather Detail")
        
        let homeButton = app.navigationBars["Weather Detail"].buttons["Home"]
        homeButton.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()
        homeButton.tap()
    }
    
    func testCancelButtonWhenSearchToShowHistoryCityList() {
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars.element(boundBy: 0).staticTexts.element.label, "Home")
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .searchField).element.tap()
        
        app.keys["P"].tap()
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
    }
    
    func testSearchInCorrectCityName() {
        
        let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .searchField).element.tap()
        app.searchFields.element.typeText("qwe")
        app.tables.staticTexts["Unable to find any matching weather location to the query submitted!"].tap()
        
        XCTAssertEqual(app.tables.children(matching: .cell).element(boundBy: 0).staticTexts.element.label, "Unable to find any matching weather location to the query submitted!")
    }
}
