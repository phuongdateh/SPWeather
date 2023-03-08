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
        interactor.weatherData = WeatherDetailData.mock().data
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
        interactor.weatherIconData = Data(count: 10)
        viewModel.weatherData = WeatherDetailData.mock().data
        let expectation = self.expectation(description: "Icon download completion")

        viewModel.downloadIcon { data in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDownloadIconWithFailedData() {
        viewModel.weatherData = nil
        let expectation = self.expectation(description: "Icon download completion")

        viewModel.downloadIcon { data in
            XCTAssertNil(data)
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

    func testDetailWeatherAttributedTextFullResult() {
        viewModel.weatherData = WeatherDetailData.mock().data

        XCTAssertNotNil(viewModel.detailWeatherAttributedText)
    }

    func testContentAttributedTextWithError() {
        interactor.errorMessage = "Failed to fetch weather data"
        let expectedAttributedText = NSAttributedString(string: "Failed to fetch weather data")

        viewModel.fetchWeather()
        let actualAttributedText = viewModel.contentAttributedText()

        XCTAssertEqual(actualAttributedText, expectedAttributedText)
    }
}
