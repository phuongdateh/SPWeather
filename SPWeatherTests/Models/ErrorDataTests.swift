//
//  ErrorDataTests.swift
//  SPWeatherTests
//
//  Created by James on 08/03/2023.
//

import XCTest
@testable import SPWeather

class ErrorDataTests: XCTestCase {
    func testCustomLocalizedDescription() {
        let message = "Test error message"
        let errorMsg = ErrorData.message(message)
        XCTAssertEqual(errorMsg.customLocalizedDescription, message)

        let errorFailedRequest = ErrorData.failedRequest
        XCTAssertEqual(errorFailedRequest.customLocalizedDescription, errorFailedRequest.localizedDescription)

        let errorInvalidResponse = ErrorData.invalidResponse
        XCTAssertEqual(errorInvalidResponse.customLocalizedDescription, errorInvalidResponse.localizedDescription)
    }
}
