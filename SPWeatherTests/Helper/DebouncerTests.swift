//
//  DebouncerTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class DebouncerTests: XCTestCase {

    var deboucer: Debouncer!
    
    override func setUp() {
        self.deboucer = Debouncer(delay: 2)
    }
    
    func testCall() {
        var isCalled: Bool = false
        let expectation = self.expectation(description: "isCalled should equal true")
        deboucer.call(action: {
            isCalled = true
            XCTAssertTrue(isCalled)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5)
    }
}
