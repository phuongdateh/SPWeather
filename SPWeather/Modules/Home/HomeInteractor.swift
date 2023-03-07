//
//  HomeInteractor.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import CoreData

protocol HomeInteractorProtocol {
    func search(cityName: String,
                success: @escaping SearchResultsAction,
                failure: @escaping StringAction)
    func getCitysLocal() -> [CityInfo]
}

class HomeInteractor: HomeInteractorProtocol {
    private var apiService: WeatherApiProtocol?
    private let coredataManager: CoreDataManager

    init(service: WeatherApiProtocol,
         coredataManager: CoreDataManager = CoreDataManager()) {
        self.apiService = service
        self.coredataManager = coredataManager
    }

    func search(cityName: String,
                success: @escaping SearchResultsAction,
                failure: @escaping StringAction) {
        apiService?.search(query: cityName, completion: { result in
            switch result {
            case .success(let searchData):
                success(searchData.results)
            case .failure(let error):
                failure(error.customLocalizedDescription)
            }
        })
    }

    func getCitysLocal() -> [CityInfo] {
        return coredataManager.fetchCityList()
    }
}
