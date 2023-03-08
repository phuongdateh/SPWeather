//
//  WeatherAPIServiceTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class WeatherAPIServiceTests: XCTestCase {
    private lazy var mockUrlSession = MockURLSession()
    private var sut: WeatherAPIService!

    override func setUp() {
        super.setUp()
        sut = WeatherAPIService(urlSession: mockUrlSession.getSession())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testDownloadImageWithSuccessResponse() {
        let expectation = expectation(description: "data image should be not nil")
        let mockImageData = Data(count: 12)
        mockUrlSession.setupResponseData(mockImageData)

        sut.downloadImage(url: "http://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png",
                          completion: { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            default: break
            }
        })

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testDownloadImageWithFailureResponse() {
        let expectation = expectation(description: "should be have an error message there")
        mockUrlSession.setupErrorResponse()

        sut.downloadImage(url: "http://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png",
                          completion: { result in
            switch result {
            case .failure(let errorData):
                let actual = errorData.customLocalizedDescription
                let expected = "Getting data image fail"
                XCTAssertEqual(actual,expected)
                expectation.fulfill()
            default: break
            }
        })

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSearchCityWithInvalidRequest() {
        let expectation = expectation(description: "should be return an invalid request error")
        mockUrlSession.setupErrorResponse()

        sut.search(query: "") { result in
            switch result {
            case .failure(let error):
                let actual = error
                let expected = ErrorData.failedRequest
                XCTAssertEqual(actual, expected)
                expectation.fulfill()
            default: break
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSearchCityWithSuccessResponse() {
        let expectation = expectation(description: "should be return an list results cities")
        mockUrlSession.setupResponseData(SearchApiResult.data())

        sut.search(query: "Test city") { result in
            switch result {
            case .success(let searchData):
                let result = searchData.results.first!
                XCTAssertTrue(!searchData.results.isEmpty)
                XCTAssertEqual(result.areaName.first!.value, "Seabrook")
                XCTAssertEqual(result.country.first!.value, "United States of America")
                XCTAssertEqual(result.region.first!.value, "Louisiana")
                expectation.fulfill()
            default: break
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSearchCityWithInvalidResponseStatusCodeGreater200() {
        let expectation = expectation(description: "should be return invalid response")
        mockUrlSession.setupErrorResponse()

        sut.search(query: "Test city") { result in
            switch result {
            case .failure(.invalidResponse):
                expectation.fulfill()
            default: break
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSearchCityInvalidResponseInvalidErrorResponse() {
        let expectation = expectation(description: "should be return invalid response")
        mockUrlSession.setupResponseData(Data(count: 10))

        sut.search(query: "Test city") { result in
            switch result {
            case .failure(.invalidResponse):
                expectation.fulfill()
            default: break
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetWeatherWithInvalidRequest() {
        let expectation = expectation(description: "should be return an invalid request error")
        mockUrlSession.setupErrorResponse()

        sut.getWeather(of: "") { result in
            switch result {
            case .failure(let error):
                let actual = error
                let expected = ErrorData.failedRequest
                XCTAssertEqual(actual, expected)
                expectation.fulfill()
            default: break
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetWeatherWithSuccessResponse() {
        let expectation = expectation(description: "should be return an list results cities")
        mockUrlSession.setupResponseData(WeatherDetailData.data())

        sut.getWeather(of: "new") { result in
            switch result {
            case .success(let weatherData):
                XCTAssertNotNil(weatherData)
                XCTAssertEqual(weatherData.cities.first!.type, "IATA")
                XCTAssertEqual(weatherData.cities.first!.query, "new, Lakefront Airport, United States of America")
                expectation.fulfill()
            default: break
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetWeatherWithInvalidResponseStatusCodeGreater200() {
        let expectation = expectation(description: "should be return invalid response")
        mockUrlSession.setupErrorResponse()

        sut.getWeather(of: "new") { result in
            switch result {
            case .failure(.invalidResponse):
                expectation.fulfill()
            default: break
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetWeatherInvalidResponseInvalidErrorResponse() {
        let expectation = expectation(description: "should be return invalid response")
        mockUrlSession.setupResponseData(Data(count: 10))

        sut.getWeather(of: "new") { result in
            switch result {
            case .failure(.invalidResponse):
                expectation.fulfill()
            default: break
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}

extension SearchApiResult {
    static func data() -> Data {
        return Utils().loadStub(name: "SearchSuccessJSON", extension: "json")
    }

    static func mock() -> SearchApiResult {
        return try! JSONDecoder().decode(SearchApiResult.self, from: SearchApiResult.data())
    }
}

extension WeatherDetailData {
    static func data() -> Data {
        return Utils().loadStub(name: "WeatherSuccessJSON", extension: "json")
    }

    static func mock() -> Self {
        return try! JSONDecoder().decode(WeatherDetailData.self, from: Self.data())
    }
}
