//
//  SearchRequestTest.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class SearchRequestTest: XCTestCase {
    
    func testInitRequestSuccessful() {
        let request = SearchRequest.init(query: "Paris")
        let urlExpected = URL.init(string: "http://api.worldweatheronline.com/premium/v1/search.ashx?key=\(Configs.NetWork.apiKey)&query=Paris&num_of_results=10&format=json")
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url, urlExpected)
    }
    
    func testInitRequestFailWithInvalidQuery() {
        let request = SearchRequest.init(query: "")
        XCTAssertNil(request)
        XCTAssertNil(request?.url)
    }
}
