//
//  CoreDataServiceTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
@testable import SPWeather

class CoreDataServiceTests: XCTestCase {
    
    var mockCoreData: MockCoreData!
    var service: CoreDataManager!
    
    override func setUp() {
        self.mockCoreData = MockCoreData.init(xctTestCase: self)
        service = CoreDataManager(container: self.mockCoreData.getMockPersistantContainer())
    }
    
    override func tearDown() {
        self.mockCoreData.flushDataInCoreData()
        super.tearDown()
    }
    
    func testInitSuccessful() {
        XCTAssertNotNil(service.persistentContainer)
    }
    
    func testFetchCityList() {
        let _ = service.insertCityItem(name: "Paris")
        service.save()
        XCTAssertTrue(service.fetchCityList().count > 0)
    }
}
