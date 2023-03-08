//
//  WeatherDetailInteractorTests.swift
//  SPWeatherTests
//
//  Created by phuong.doand on 06/09/2021.
//

import XCTest
import CoreData
@testable import SPWeather

class WeatherDetailInteractorTests: XCTestCase {
    lazy var apiServiceMock = WeatherApiServiceMock()
    var sut: WeatherDetailInteractor!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager(container: MockCoreData(xctTestCase: self).getMockPersistantContainer())
        sut = WeatherDetailInteractor(apiService: apiServiceMock, coreDataManager: mockCoreDataManager)
    }
    
    func testSaveCityWhenCityNameExistsShouldUpdateCity() {
        let cityName = "London"
        let mockCityItem = CityInfo(context: mockCoreDataManager.persistentContainer.viewContext)
        mockCityItem.name = cityName
        mockCoreDataManager.mockCity = mockCityItem

        sut.saveCity(with: cityName)

        XCTAssertTrue(mockCoreDataManager.updateCityCalled)
        XCTAssertEqual(mockCoreDataManager.updatedCityName, cityName)
    }
    
    func testSaveCityWhenCityNameDoesNotExistShouldInsertCity() {
        let cityName = "New York"
        mockCoreDataManager.mockCityList = []

        sut.saveCity(with: cityName)

        XCTAssertTrue(mockCoreDataManager.insertCityItemCalled)
        XCTAssertEqual(mockCoreDataManager.insertedCityName, cityName)
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
