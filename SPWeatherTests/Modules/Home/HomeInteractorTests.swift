//
//  HomeInteractorTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class HomeInteractorTests: XCTestCase {
    
    var interactor: HomeInteractor!

    override func setUp() {
        let config = URLSessionConfiguration.default
        let apiService = WeatherAPIService.init(urlSession: URLSession(configuration: config))
        self.interactor = HomeInteractor.init(service: apiService)
    }
    
    func testSearchWithCorrectInCityName() {
        let expectation = self.expectation(description: "should return error message")
        interactor.search(cityName: "aaaaaaaaaaaa", successBlock: nil, failBlock: { errorMsg in
            XCTAssertEqual(errorMsg, "Unable to find any matching weather location to the query submitted!")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5)
    }

    func testSearchWithCorrectCityName() {
        let expectation = self.expectation(description: "should return list result data")
        interactor.search(cityName: "Paris", successBlock: { results in
            XCTAssertTrue(results.count > 0)
            XCTAssertEqual(results.first?.areaName.first?.value, "Paris")
            XCTAssertEqual(results.first!.country.first!.value, "France")
            expectation.fulfill()
        }, failBlock: nil)
        
        waitForExpectations(timeout: 5)
    }
}
