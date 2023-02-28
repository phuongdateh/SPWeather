//
//  WeatherAPIServiceStubNetworkTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class WeatherAPIServiceStubNetworkTests: XCTestCase {
    
    var urlSession: URLSession!
    var apiService: WeatherAPIService!
    var stubData: Data!

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        apiService = WeatherAPIService.init(urlSession: urlSession)
    }
    
    func testSearchSuccessful() {
        let expectation = self.expectation(description: "areaName is Seabrook")
        stubData = self.loadStub(name: "SearchSuccessJSON", extension: "json")
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), self.stubData)
        }
        
        apiService.search(query: "Seabrook") { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.results.first!.areaName.first!.value, "Seabrook")
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testSearchFailResultReturnErrorMessage() {
        let expectation = self.expectation(description: "should be return error message no matching location which query")
        stubData = self.loadStub(name: "SearchErrorJSON", extension: "json")
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), self.stubData)
        }
        
        apiService.search(query: "qwe") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.customLocalizedDescription, "Unable to find any matching weather location to the query submitted!")
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetWeatherSuccessfulHaveCurrentConditionData() {
        let expectation = self.expectation(description: "current condition should be have tempC, humidity")
        stubData = self.loadStub(name: "WeatherSuccessJSON", extension: "json")
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), self.stubData)
        }
        
        apiService.getWeather(of: "new") { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.currentCondition.first!.humidity, "78")
                XCTAssertEqual(data.currentCondition.first!.tempC, "26")
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetWeatherFailWhichInCorrectCityNameReturnErrorMessage() {
        let expectation = self.expectation(description: "should be return error message no matching location which in correct city name")
        stubData = self.loadStub(name: "WeatherErrorJSON", extension: "json")
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), self.stubData)
        }
        
        apiService.getWeather(of: "qwe") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.customLocalizedDescription, "Unable to find any matching weather location to the query submitted!")
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5)
    }


}
