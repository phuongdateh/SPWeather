//
//  WeatherDetailInteractorTests.swift
//  SPWeatherTests
//
//  Created by phuong.doand on 06/09/2021.
//

import XCTest
@testable import SPWeather

class WeatherDetailInteractorTests: XCTestCase {
    
    lazy var apiServiceMock = WeatherApiServiceMock()
    var sut: WeatherDetailInteractor!
    
    override func setUp() {
        sut = WeatherDetailInteractor.init(apiService: apiServiceMock)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testGetWeatherWithSuccessResponse() {
        let expectation = self.expectation(description: "success block should be called")
        apiServiceMock.weatherData = WeatherData.mock

        sut.getWeather(cityName: "London") { data in
            XCTAssertTrue(data.cities.isEmpty == false)
            XCTAssertTrue(data.currentCondition.isEmpty == false)
            expectation.fulfill()
        } failure: { error in }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetWeatherWithFailureResponse() {
        let expectation = self.expectation(description: "failure block should be called")
        apiServiceMock.weatherData = nil

        sut.getWeather(cityName: "ABC") { data in
        } failure: { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testDownLoadIconImageWithSuccessResponse() {
        let expectation = self.expectation(description: "Success block should be called")
        apiServiceMock.imageData = Data(count: 10)

        sut.getWeatherIcon(url: "https://") { data in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testDownLoadIconImageWithFailureResponse() {
        let expectation = self.expectation(description: "Failure block should be called")
        apiServiceMock.imageData = nil

        sut.getWeatherIcon(url: "https://") { data in
            XCTAssertNil(data)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

}
