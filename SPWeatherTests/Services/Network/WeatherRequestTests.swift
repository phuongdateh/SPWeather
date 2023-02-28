//
//  WeatherRequestTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class WeatherRequestTests: XCTestCase {
    
    func testInitRequestSuccessful() {
        let request = WeatherRequest(query: "Paris")
        let urlExpected = URL.init(string: "http://api.worldweatheronline.com/premium/v1/weather.ashx?key=\(Configs.NetWork.apiKey)&q=Paris&num_of_days=12&tp=3&format=json")
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url, urlExpected)
    }
    
    func testInitRequestFailWithInvalidQuery() {
        let request = WeatherRequest.init(query: "")
        XCTAssertNil(request)
        XCTAssertNil(request?.url)
    }
}
