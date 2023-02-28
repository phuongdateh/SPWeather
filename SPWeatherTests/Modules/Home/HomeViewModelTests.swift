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
        let interactor = HomeInteractor.init(service: apiService)
        viewModel = HomeViewModel.init(interactor: interactor)
        
        let city1 = CityInfo.init()
        cityList.append(city1)
        
        // Search Data Successful
        let searchDataSuccess = loadStub(name: "SearchSuccessJSON", extension: "json")
        let searchJsonSuccess = try JSONSerialization.jsonObject(with: searchDataSuccess, options: []) as! [String: Any]
        let searchDataJson = searchJsonSuccess["search_api"] as! [String: Any]
        self.searchData = apiService.parseSearchData(searchDataJson)
        
    }
    
    func testSearchWithCorrectCityName() {
        let expectation = self.expectation(description: "shourd return list homeViewModeItem")
        viewModel.search(query: "Paris")
        viewModel.didChangeData = { items in
            XCTAssertTrue(items.count > 0)
            let firstItem = items.first!
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
        viewModel.didChangeData = { items in
            switch items.first! {
            case .searchFail(let msg):
                XCTAssertTrue(items.count == 1)
                XCTAssertEqual(msg, "Unable to find any matching weather location to the query submitted!")
            default:
                break
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
        let viewModelItems = viewModel.prepareSearchingViewModelItems(self.searchData.results)
        XCTAssertTrue(viewModelItems.isEmpty == false)
    }
    
    func testPrepareSearchFailViewModelItems() {
        let viewModelItems = viewModel.prepareSearchFailViewModelItems("Test")
        XCTAssertTrue(viewModelItems.count == 1)
    }
    
    func testPrepareSearchHistoryViewModelItemsHaveItems() {
        let items = viewModel.prepareSearchHistoryViewModelItems(cityList)
        XCTAssertNotNil(items)
    }
    
    func testInitalViewStateCurrentCityListNil() {
        viewModel.currentCityList = nil
        viewModel.initalViewState()
        XCTAssertEqual(viewModel.viewState, .empty)
    }
    
    func testInitalViewStateExitHistoryCityList() {
        viewModel.currentCityList = cityList
        viewModel.initalViewState()
        XCTAssertEqual(viewModel.viewState, .history)
    }
}
