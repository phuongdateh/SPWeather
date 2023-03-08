//
//  HomeInteractorTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class HomeInteractorTests: XCTestCase {
    lazy var mockApiService = WeatherApiServiceMock()
    var mockCoreData: MockCoreDataManager!
    var interactor: HomeInteractor!

    override func setUp() {
        mockCoreData = MockCoreDataManager(container: MockCoreData(xctTestCase: self).getMockPersistantContainer())
        interactor = HomeInteractor(service: mockApiService, coredataManager: mockCoreData)
    }

    override func tearDown() {
        interactor = nil
    }

    func testSearchWithFailureResponse() {
        let expectation = expectation(description: "should return an error message")
        mockApiService.searchData = nil

        interactor.search(cityName: "Wrong City name") { _ in
        } failure: { errorMsg in
            XCTAssertEqual(errorMsg, "Failure data")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSearchWithSuccessResponse() {
        let expectation = expectation(description: "should return an results")
        mockApiService.searchData = mockSearchData

        interactor.search(cityName: "Seabrook") { results in
            XCTAssertTrue(!results.isEmpty)
            let actualAreaname = "Seabrook"
            let expected = results.first?.areaName.first?.value
            XCTAssertEqual(actualAreaname, expected)
            expectation.fulfill()
        } failure: { _ in }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testManagedObjectContextDidSave() {
        let expectation = expectation(description: "ObjectContextDidSave notification should be posted")

        interactor.registerObjectContextDidSave {
            expectation.fulfill()
        }

        mockCoreData.triggerObjectContextDidSave()
        waitForExpectations(timeout: 2, handler: nil)
    }

    lazy var mockSearchData: SearchData = {
        return SearchApiResult.mock().searchData
    }()
}
