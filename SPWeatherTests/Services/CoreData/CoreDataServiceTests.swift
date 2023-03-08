//
//  CoreDataServiceTests.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import XCTest
import CoreData
@testable import SPWeather


class CoreDataServiceTests: XCTestCase {
    
    var mockCoreData: MockCoreData!
    var coreDataManager: CoreDataManager!

    override func setUp() {
        mockCoreData = MockCoreData(xctTestCase: self)
        coreDataManager = CoreDataManager(container: self.mockCoreData.getMockPersistantContainer())
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        let container = NSPersistentContainer(name: "SPWeather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        coreDataManager = CoreDataManager(container: container)
    }
    
    override func tearDown() {
        self.mockCoreData.flushDataInCoreData()
        super.tearDown()
    }
    
    func testInitSuccessful() {
        XCTAssertNotNil(coreDataManager.persistentContainer)
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
        try super.tearDownWithError()
    }
    
    func testInsertCityItem() {
        let cityName = "Test City"
        let cityItem = coreDataManager.insertCityItem(name: cityName)
        XCTAssertNotNil(cityItem)
        XCTAssertEqual(cityItem?.name, cityName)
    }
    
    func testUpdateCity() {
        let cityName = "Test City"
        _ = coreDataManager.insertCityItem(name: cityName)
        coreDataManager.save()
        
        coreDataManager.updateCity(with: cityName)
        let request: NSFetchRequest<CityInfo> = CityInfo.fetchRequest()
        request.predicate = NSPredicate(format: "name LIKE %@", cityName)
        let cityList = try? coreDataManager.persistentContainer.viewContext.fetch(request)
        let updatedCity = cityList?.first
        XCTAssertNotNil(updatedCity)
        XCTAssertEqual(updatedCity?.name, cityName)
        XCTAssertNotNil(updatedCity?.createdAt)
    }
    
    func testFetchCityList() {
        let cityNames = ["Tua", "China", "Tala"]
        for cityName in cityNames {
            let _ = coreDataManager.insertCityItem(name: cityName)
        }
        coreDataManager.save()

        let cityList = coreDataManager.fetchCityList()
        XCTAssertEqual(cityList.count, 3)
        XCTAssertEqual(cityList[0].name, "Tala")
        XCTAssertEqual(cityList[1].name, "China")
        XCTAssertEqual(cityList[2].name, "Tua")
    }

    func testFetchCityWithName() {
        let cityNames = ["Testla"]
        for cityName in cityNames {
            let _ = coreDataManager.insertCityItem(name: cityName)
        }
        coreDataManager.save()

        let actual = coreDataManager.fetchCity(with: "Testla")
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual!.name, "Testla")
    }
    
    func testSave() {
        let cityName = "Test City"
        let _ = coreDataManager.insertCityItem(name: cityName)
        XCTAssertTrue(coreDataManager.backgroundContext.hasChanges)
        coreDataManager.save()
        XCTAssertFalse(coreDataManager.backgroundContext.hasChanges)
    }

    func testNotifyObjectContextDidSave() {
        let notificationExpectation = expectation(
            forNotification: Notification.Name(rawValue: CustomNotificationName.managedObjectContextDidSave.rawValue),
            object: nil,
            handler: nil
        )

        coreDataManager.notifyObjectContextDidSave()

        wait(for: [notificationExpectation], timeout: 1)
    }

    func testRegisterObjectContextDidSave() {
        let notificationExpectation = expectation(description: "Notification should be posted")
        coreDataManager.registerObjectContextDidSave {
            notificationExpectation.fulfill()
        }

        NotificationCenter.default.post(
                    name: NSNotification.Name.NSManagedObjectContextDidSave,
                    object: coreDataManager.persistentContainer.viewContext
        )

        wait(for: [notificationExpectation], timeout: 1)
    }
}
