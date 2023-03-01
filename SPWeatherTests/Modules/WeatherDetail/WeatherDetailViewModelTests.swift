//
//  WeatherDetailViewModelTests.swift
//  SPWeatherTests
//
//  Created by phuong.doand on 06/09/2021.
//

import XCTest
@testable import SPWeather

class WeatherDetailViewModelTests: XCTestCase {
    var interactor: MockWeatherDetailInteractor!
    var viewModel: WeatherDetailViewModel!

    override func setUp() {
        super.setUp()
        interactor = MockWeatherDetailInteractor()
        viewModel = WeatherDetailViewModel(interactor, city: "New York")
    }

    override func tearDown() {
        interactor = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() {
        interactor.weatherData = MockData.weatherData
        let expectedViewState: WeatherDetailViewModel.ViewState = .loaded

        viewModel.fetchWeather()

        XCTAssertEqual(viewModel.viewState, expectedViewState)
        XCTAssertNotNil(viewModel.weatherData)
    }

    func testFetchWeatherFailure() {
        interactor.errorMessage = "Failed to fetch weather data"
        let expectedViewState: WeatherDetailViewModel.ViewState = .loaded

        viewModel.fetchWeather()

        XCTAssertEqual(viewModel.viewState, expectedViewState)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testDownloadIcon() {
        interactor.weatherIconData = MockData.weatherIconData
        viewModel.weatherData = MockData.weatherData
        let expectation = self.expectation(description: "Icon download completion")

        viewModel.downloadIcon { data in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testContentAttributedText() {
        interactor.weatherData = nil
        let expectedAttributedText = viewModel.detailWeatherAttributedText

        viewModel.fetchWeather()
        let attributedText = viewModel.contentAttributedText()

        XCTAssertEqual(attributedText, expectedAttributedText)
    }

    func testContentAttributedTextWithError() {
        interactor.errorMessage = "Failed to fetch weather data"
        let expectedAttributedText = NSAttributedString(string: "Failed to fetch weather data")

        viewModel.fetchWeather()
        let attributedText = viewModel.contentAttributedText()

        XCTAssertEqual(attributedText, expectedAttributedText)
    }
}

class MockWeatherDetailInteractor: WeatherDetailInteractorProtocol {
    var weatherData: WeatherData?
    var weatherIconData: Data?
    var errorMessage: String?

    func getWeather(cityName: String, success: @escaping WeatherDataAction, failure: @escaping StringAction) {
        if let weatherData = weatherData {
            success(weatherData)
        } else if let errorMessage = errorMessage {
            failure(errorMessage)
        }
    }

    func getWeatherIcon(url: String, completion: @escaping DataAction) {
        if let weatherIconData = weatherIconData {
            completion(weatherIconData)
        }
    }
}

struct MockData {
    static let weatherData = WeatherData.mock
    static let weatherIconData = Data(count: 10)
}

extension WeatherData {
    static var mock: WeatherData {
        let cities: [City] = [
            City(type: "city", query: "New York")
        ]
        let currentCondition: [CurrentCondition] = [
            CurrentCondition(humidity: "29",
                             tempC: "6",
                             tempF: "22",
                             weatherIconUrl: [CurrentCondition.Value(value: "https://www.google.com/icon.png")],
                             weatherDesc: [CurrentCondition.Value(value: "Sunny")])
        ]
        return WeatherData(cities: cities, currentCondition: currentCondition)
    }
}

