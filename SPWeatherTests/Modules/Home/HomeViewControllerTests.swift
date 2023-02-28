//
//  HomeViewControllerTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class HomeViewControllerTests: XCTestCase {

    var mockCoreData: MockCoreData!
    var viewController: HomeViewController!
    var coredataManager: CoreDataManager!
    
    override func setUp() {
        self.mockCoreData = MockCoreData(xctTestCase: self)
        self.coredataManager = CoreDataManager.init(container: self.mockCoreData.getMockPersistantContainer())
        self.initStubsCoreData()
        let interactor = HomeInteractor.init(service: WeatherAPIService.init(),
                                             coredataManager: coredataManager)
        let viewModel = HomeViewModel.init(interactor: interactor)
        viewController = HomeViewController.fromNib(ofType: HomeViewController.self, viewModel: viewModel, navigator: Navigator()) as? HomeViewController
        viewController?.loadViewIfNeeded()
        let _ = viewController?.view
    }
    
    override func tearDown() {
        self.mockCoreData.flushDataInCoreData()
        super.tearDown()
    }
    
    func testHomeViewController() {
        XCTAssertEqual(viewController?.title, "Home")
    }
    
    func testHomeViewControllerCanBeInstantiated() {
        XCTAssertNotNil(viewController.searchBar)
    }
    
    func testHomeViewControllerShouldSetSearchBarDelegate() {
        XCTAssertNotNil(self.viewController.searchBar.delegate)
    }

    func testHomeViewControllerConformsToSearchBarDelegateProtocol() {
        XCTAssert(HomeViewController.conforms(to: UISearchBarDelegate.self))
        XCTAssertTrue(self.viewController.responds(to: #selector(viewController.searchBar(_:textDidChange:))))
        XCTAssertTrue(self.viewController.responds(to: #selector(viewController.searchBarCancelButtonClicked(_:))))
    }
    
    func testHasATableView() {
        XCTAssertNotNil(viewController.tableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewController.tableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(viewController.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:didSelectRowAt:))))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewController.tableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewController.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.numberOfSections(in:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:cellForRowAt:))))
    }

    func testTableViewCellHasReuseIdentifier() {
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? HomeTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "HomeTableViewCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testTableCellHasCorrectLabelText() {
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? HomeTableViewCell
        switch viewController.viewModelItems?.first! {
        case .searchFail(let msg):
            XCTAssertEqual(cell?.contentLbl.text, msg)
        case .searchHistory(let city):
            XCTAssertEqual(cell?.contentLbl.text, city.name!)
        case .searching(let results):
            XCTAssertEqual(cell?.contentLbl.text, results.areaName[0].value)
        default: break
        }
    }

}

extension HomeViewControllerTests {
    func initStubsCoreData() {
        let _ = coredataManager.insertCityItem(name: "paris")
        let _ = coredataManager.insertCityItem(name: "new")
        coredataManager.save()
    }
}
