//
//  WeatherDetailInteractorTests.swift
//  SPWeatherTests
//
//  Created by phuong.doand on 06/09/2021.
//

import XCTest
@testable import SPWeather
class WeatherDetailInteractorTests: XCTestCase {
    
    var interactor: WeatherDetailInteractor!
    
    override func setUp() {
        let apiService = WeatherAPIService.init()
        interactor = WeatherDetailInteractor.init(apiService: apiService)
    }
    
    func testGetWeatherWithCorrectCityName() {
        let expectation = self.expectation(description: "result should be have city name contain new")
        interactor.getWeather(cityName: "new", successBlock: { data in
            XCTAssertEqual(data.cities.first?.query, "new, Lakefront Airport, United States of America")
            expectation.fulfill()
        }, failBlock: nil)
        waitForExpectations(timeout: 5)
    }
    
    func testGetWeatherWithInCorrectCityName() {
        let expectation = self.expectation(description: "fail compltion will be excute and return error message")
        interactor.getWeather(cityName: "nnnnnnn", successBlock: nil, failBlock: { errorMessage in
            XCTAssertEqual(errorMessage, "Unable to find any matching weather location to the query submitted!")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5)
    }
}
