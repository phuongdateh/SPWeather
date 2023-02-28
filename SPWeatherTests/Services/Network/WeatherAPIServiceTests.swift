//
//  WeatherAPIServiceTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class WeatherAPIServiceTests: XCTestCase {
    
    private var weatherAPI: WeatherAPIService!
    
    override func setUp() {
        super.setUp()
        weatherAPI = WeatherAPIService(urlSession: URLSession(configuration: URLSessionConfiguration.default))
    }
    
    func testParseJSONSearchDataSuccessful() throws {
        let data = loadStub(name: "SearchSuccessJSON", extension: "json")
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let dataJson = json["search_api"] as! [String: Any]
        let searchData = weatherAPI.parseSearchData(dataJson)
        XCTAssertNotNil(searchData)
        XCTAssertTrue(searchData?.results.isEmpty == false)
        XCTAssertEqual(searchData?.results.first?.areaName.first!.value, "Seabrook")
    }
    
    func testParseWeatherDataSuccessful() throws {
        let data = loadStub(name: "WeatherSuccessJSON", extension: "json")
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let dataJson = json["data"] as! [String: Any]
        let weatherData = weatherAPI.parseWeatherData(dataJson)
        XCTAssertNotNil(weatherData)
        XCTAssertTrue(weatherData?.cities.isEmpty == false)
        XCTAssertTrue(weatherData?.currentCondition.isEmpty == false)
    }
    
    func testParseSearchDataErrorRessponseSuccessful() throws {
        let data = loadStub(name: "SearchErrorJSON", extension: "json")
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let dataJson = json["data"] as! [String: Any]
        let errorData = weatherAPI.parseErrorData(dataJson)
        XCTAssertNotNil(errorData)
        XCTAssertTrue(errorData?.errors.isEmpty == false)
    }
    
    func testGetWeatherSuccessful() {
        let dataExpectation = self.expectation(description: "test get weather with correct city name")
        
        weatherAPI.getWeather(of: "Paris") { results in
            switch results {
            case .success(let data):
                XCTAssertTrue(data.cities.isEmpty == false)
                XCTAssertEqual(data.cities.first!.query, "Paris, France")
                dataExpectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetWeatherInCorrectCityName() {
        let dataExpectation = self.expectation(description: "should be return error message")
        weatherAPI.getWeather(of: "qwe") { results in
            switch results {
            case .failure(let error):
                XCTAssertEqual(error.customLocalizedDescription, "Unable to find any matching weather location to the query submitted!")
                dataExpectation.fulfill()
            default:
                break
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testSearchCityFailWithInCorrectCityName() {
        let dataExpectation = self.expectation(description: "should be is fail complition and return error message unable to find this city name")
        weatherAPI.search(query: "cityNameCorrect") { results in
            switch results {
            case .failure(let error):
                XCTAssertEqual(error.customLocalizedDescription, "Unable to find any matching weather location to the query submitted!")
                dataExpectation.fulfill()
            default:
                break
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testSearchCitySuccessfulWithCorrectCityName() {
        let dataExpectation = self.expectation(description: "should be return list result city")
        weatherAPI.search(query: "Paris") { result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data.results.isEmpty == false)
                XCTAssertEqual(data.results.first!.areaName.first!.value, "Paris")
                XCTAssertEqual(data.results.first!.country.first!.value, "France")
                XCTAssertEqual(data.results.first!.region.first!.value, "Ile-de-France")
                dataExpectation.fulfill()
            default:
                break
            }
        }
        
        waitForExpectations(timeout: 5)
    }
}
