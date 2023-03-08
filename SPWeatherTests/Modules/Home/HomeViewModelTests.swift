//
//  HomeViewModelTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather
import CoreData

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    
    var searchData: SearchData!
    var errorMessage: String!
    var cityList = [CityInfo]()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let config = URLSessionConfiguration.default
        let apiService = WeatherAPIService(urlSession: URLSession.init(configuration: config))
        let interactor = HomeInteractor(service: apiService)
        viewModel = HomeViewModel.init(interactor: interactor)
        
        let city1 = CityInfo.init()
        cityList.append(city1)

        // Search Data Successful
        self.searchData = SearchApiResult.mock().searchData
    }
    
    func testSearchWithCorrectCityName() {
        let expectation = self.expectation(description: "shourd return list homeViewModeItem")
        viewModel.search(query: "Paris")
        viewModel.didUpdateViewState = { state in
            let firstItem = self.viewModel.dataForCell(at: IndexPath(row: 0, section: 0))
            switch firstItem {
            case .searching(let result):
                XCTAssertEqual(result.areaName.first!.value, "Paris")
                XCTAssertEqual(result.country.first!.value, "France")
                XCTAssertEqual(result.region.first!.value, "Ile-de-France")
                expectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testSearchWithInCorrectCityName() {
        let expectation = self.expectation(description: "should be return error message")
        viewModel.search(query: "qwe")
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
        viewModel.prepareSearchingViewModelItems(self.searchData.results)
        XCTAssertTrue(viewModel.viewModelItems.isEmpty == false)
    }
    
    func testPrepareSearchFailViewModelItems() {
        viewModel.prepareSearchFailViewModelItems("Test")
        XCTAssertTrue(viewModel.viewModelItems.count == 1)
    }
    
    func testPrepareSearchHistoryViewModelItemsHaveItems() {
        viewModel.prepareSearchHistoryViewModelItems(cityList)
        XCTAssertTrue(viewModel.viewModelItems.isEmpty == false)
    }
    
    func testInitalViewStateCurrentCityListNil() {
        viewModel.currentCityList = [CityInfo]()
        viewModel.initalViewState()
        XCTAssertEqual(viewModel.viewState, .empty)
    }
    
    func testInitalViewStateExitHistoryCityList() {
        viewModel.currentCityList = cityList
        viewModel.initalViewState()
        XCTAssertEqual(viewModel.viewState, .history)
    }

    func testResetViewStateExpectedHistoryState() {
        viewModel.viewModelItems = []
        viewModel.resetViewState()
        let actual = viewModel.viewState!
        let expected = HomeViewState.history
        XCTAssertEqual(actual, expected)
    }
}
