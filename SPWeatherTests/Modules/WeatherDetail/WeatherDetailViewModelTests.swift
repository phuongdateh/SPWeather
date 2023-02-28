//
//  WeatherDetailViewModelTests.swift
//  SPWeatherTests
//
//  Created by phuong.doand on 06/09/2021.
//

import XCTest
@testable import SPWeather

class WeatherDetailViewModelTests: XCTestCase {

    var mockCoreData: MockCoreData!
    var interactor: WeatherDetailInteractor!
    var viewModel: WeatherDetailViewModel!
    
    override func setUp() {
        self.mockCoreData = MockCoreData(xctTestCase: self)
        let configuration = URLSessionConfiguration.default
        self.interactor = WeatherDetailInteractor.init(apiService: WeatherAPIService(urlSession: URLSession(configuration: configuration)),
                                                       coreDataManager: CoreDataManager.init(container: self.mockCoreData.getMockPersistantContainer()))
        self.viewModel = WeatherDetailViewModel.init(interactor, city: "")
    }
    
    func testGetWeatherSuccessfulWithCorrectCityName() {
        let dataExpectation = self.expectation(description: "should be return current condition weather")
        viewModel.city = "new"
        viewModel.getWeather(successBlock: { data in
            XCTAssertEqual(data.cities.first!.query, "new, Lakefront Airport, United States of America")
            XCTAssertTrue(data.currentCondition.isEmpty == false)
            XCTAssertTrue(data.currentCondition.first!.humidity.isEmpty == false)
            XCTAssertTrue(data.currentCondition.first!.tempC.isEmpty == false)
            dataExpectation.fulfill()
        }, failBlock: nil)
        
        waitForExpectations(timeout: 5)
    }
    
    func testGetWeatherSuccessfulWithInCorrectCityName() {
        let dataExpectation = self.expectation(description: "should be return error message")
        viewModel.city = "abcdegh"
        viewModel.getWeather(successBlock: nil, failBlock: { error in
            XCTAssertEqual(error, "Unable to find any matching weather location to the query submitted!")
            dataExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5)
    }
    
    func testGetWeatherIconWithValidURL() {
        let dataExpectation = self.expectation(description: "shourd be return Data to init UIImage")
        viewModel.getWeatherIcon(url: "http://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png") { data in
            XCTAssertNotNil(data)
            XCTAssertNotNil(UIImage(data: data!))
            dataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testGetWeatherIconWithInValidURL() {
        let dataExpectation = self.expectation(description: "should be return Data nil")
        viewModel.getWeatherIcon(url: "invalid") { data in
            XCTAssertNil(data)
            dataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }

}
