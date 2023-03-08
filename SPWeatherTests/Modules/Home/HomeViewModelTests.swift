//
//  HomeViewModelTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
import CoreData
@testable import SPWeather

class HomeViewModelTests: XCTestCase {
    lazy var mockInteractor = MockHomeInteractor()
    var viewModel: HomeViewModel!

    override func setUp() {
        viewModel = HomeViewModel(interactor: mockInteractor)
    }

    override func tearDown() {
        viewModel = nil
    }

    func testSearchWithEmptyCitynameExpectedViewStateNil() {
        mockInteractor.cityList = [CityInfo()]
        viewModel.search(query: "")

        XCTAssertNil(viewModel.viewState)
    }

    func testSearchWithCorrectCityName() {
        let expectation = self.expectation(description: "shourd return list homeViewModeItem")
        mockInteractor.searchApiResult = SearchApiResult.mock()

        viewModel.search(query: "Paris")
        viewModel.didUpdateViewState = { state in
            let firstItem = self.viewModel.dataForCell(at: IndexPath(row: 0, section: 0))
            switch firstItem {
            case .searching(let result):
                XCTAssertEqual(result.areaName.first!.value, "Seabrook")
                XCTAssertEqual(result.country.first!.value, "United States of America")
                XCTAssertEqual(result.region.first!.value, "Louisiana")
                expectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDataForCellExpectedNilResult() {
        mockInteractor.cityList = []

        let dataForCell = viewModel.dataForCell(at: IndexPath(row: 1, section: 0))
        XCTAssertNil(dataForCell)
    }
    
    func testSearchWithInCorrectCityName() {
        let expectation = self.expectation(description: "should be return error message")
        mockInteractor.errorMsg = "Unable to find any matching weather location to the query submitted!"

        viewModel.search(query: "Wrong city name")
        viewModel.didUpdateViewState = { state in
            let firstItem = self.viewModel.dataForCell(at: IndexPath(row: 0, section: 0))
            switch firstItem {
            case .searchFail(let msg):
                XCTAssertEqual(msg, "Unable to find any matching weather location to the query submitted!")
            default: break
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testCreateWeatherDetailViewModel() {
        let newViewModel = viewModel.createWeatherDetailViewModel(city: "new")
        XCTAssertEqual(newViewModel.city, "new")
    }
    
    func testPrepareSearchingViewModelItems() {
        viewModel.prepareSearchingViewModelItems(SearchApiResult.mock().searchData.results)
        XCTAssertTrue(viewModel.viewModelItems.isEmpty == false)
    }
    
    func testPrepareSearchFailViewModelItems() {
        viewModel.prepareSearchFailViewModelItems("Test")
        XCTAssertTrue(viewModel.viewModelItems.count == 1)
    }
    
    func testPrepareSearchHistoryViewModelItemsHaveItems() {
        mockInteractor.cityList = [CityInfo()]

        viewModel.prepareSearchHistoryViewModelItems(mockInteractor.cityList)
        XCTAssertTrue(viewModel.viewModelItems.isEmpty == false)
    }
    
    func testInitalViewStateCurrentCityListNil() {
        viewModel.currentCityList = [CityInfo]()
        viewModel.initalViewState()
        XCTAssertEqual(viewModel.viewState, .empty)
    }
    
    func testInitalViewStateExitHistoryCityList() {
        mockInteractor.cityList = [CityInfo()]
        viewModel.currentCityList = mockInteractor.cityList

        viewModel.initalViewState()
        XCTAssertEqual(viewModel.viewState, .history)
    }

    func testResetViewStateExpectedHistoryState() {
        mockInteractor.cityList = [CityInfo()]
        viewModel.viewModelItems = []

        viewModel.resetViewState()

        let actual = viewModel.viewState!
        let expected = HomeViewState.history
        XCTAssertEqual(actual, expected)
    }

    func testResetViewStateExpectedEmptyState() {
        mockInteractor.cityList = [CityInfo]()

        viewModel.resetViewState()

        let actual = viewModel.viewState!
        let expected = HomeViewState.empty
        XCTAssertEqual(actual, expected)
    }

    func testUpdateCityListWhenObjectContextDidSave() {
        let expectation = expectation(description: "ObjectContextDidSave notification should be posted")
        mockInteractor.registerObjectContextDidSave {
            print("sasdasd")
        }
        viewModel.registerObjectContextDidSave {
            expectation.fulfill()
        }
        mockInteractor.triggerObjectContextDidSave()
        waitForExpectations(timeout: 2, handler: nil)
    }
}
