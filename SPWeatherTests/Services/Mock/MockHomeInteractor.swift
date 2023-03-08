//
//  MockHomeInteractor.swift
//  SPWeatherTests
//
//  Created by James on 08/03/2023.
//

import Foundation
@testable import SPWeather

class MockHomeInteractor: HomeInteractorProtocol {
    var searchApiResult: SearchApiResult?
    var errorMsg: String?
    var objectContextDidSaveIsCalled: Bool = false
    var objectContextDidSave: VoidAction?

    var cityList = [CityInfo]()

    func search(cityName: String,
                success: @escaping SearchResultsAction,
                failure: @escaping StringAction) {
        guard let searchApiResult else {
            failure(errorMsg ?? "Not yet set error message")
            return
        }
        success(searchApiResult.searchData.results)
    }

    func getCitysLocal() -> [CityInfo] {
        return cityList
    }

    func registerObjectContextDidSave(action: @escaping VoidAction) {
        objectContextDidSave = action
    }

    func triggerObjectContextDidSave() {
        objectContextDidSave?()
    }
}
