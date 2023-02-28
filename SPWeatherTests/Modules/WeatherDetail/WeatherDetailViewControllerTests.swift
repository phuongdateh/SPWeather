//
//  WeatherDetailViewControllerTests.swift
//  SPWeatherTests
//
//  Created by phuong.doand on 06/09/2021.
//

import XCTest
@testable import SPWeather

class WeatherDetailViewControllerTests: XCTestCase {
    
    var mockCoreData: MockCoreData!
    var viewController: WeatherDetailViewController!
    var interactor: WeatherDetailInteractor!
    
    override func setUp() {
        self.mockCoreData = MockCoreData.init(xctTestCase: self)
        let coreDataManager = CoreDataManager.init(container: self.mockCoreData.getMockPersistantContainer())
        self.interactor = WeatherDetailInteractor(apiService: WeatherAPIService.init(),
                                                  coreDataManager: coreDataManager)
    }

    override func tearDown() {
        self.mockCoreData.flushDataInCoreData()
        super.tearDown()
    }
    
    func testviewControllerWithCorrectCityName() {
        let viewModel = WeatherDetailViewModel.init(interactor, city: "paris")
        viewController = WeatherDetailViewController.fromNib(ofType: WeatherDetailViewController.self, viewModel: viewModel, navigator: Navigator.init()) as? WeatherDetailViewController
        viewController.loadViewIfNeeded()
        XCTAssertEqual(viewController.title, "Weather Detail")
    }
    
    func testHomeViewWithInCorrectCityName() {
        let viewModel = WeatherDetailViewModel.init(interactor, city: "qwe")
        viewController = WeatherDetailViewController.fromNib(ofType: WeatherDetailViewController.self, viewModel: viewModel, navigator: Navigator.init()) as? WeatherDetailViewController
        viewController.loadViewIfNeeded()
        XCTAssertEqual(viewController.title, "Weather Detail")
    }
}
