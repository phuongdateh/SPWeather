//
//  MockCoreDataManager.swift
//  SPWeatherTests
//
//  Created by James on 08/03/2023.
//

import Foundation
import CoreData
@testable import SPWeather

class MockCoreDataManager: CoreDataManagerInterface {
    var mockCityList: [CityInfo] = []
    var updateCityCalled = false
    var updatedCityName: String?
    var insertCityItemCalled = false
    var insertedCityName: String?

    var mockCity: CityInfo?

    let persistentContainer: NSPersistentContainer

    init(container: NSPersistentContainer) {
        persistentContainer = container
    }
    
    func fetchCityList() -> [CityInfo] {
        return mockCityList
    }
    
    func updateCity(with cityName: String) {
        updateCityCalled = true
        updatedCityName = cityName
    }
    
    func insertCityItem(name: String) -> CityInfo? {
        insertCityItemCalled = true
        insertedCityName = name
        return CityInfo(context: persistentContainer.viewContext)
    }

    func fetchCity(with name: String) -> CityInfo? {
        return mockCity
    }
    
    func save() {
        updateCityCalled = true
    }
}
