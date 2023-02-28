//
//  HomeInteractor.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import CoreData

protocol HomeInteractorProtocol {
    func search(cityName: String, successBlock: (([SearchResult]) -> ())?, failBlock: ((String) -> ())?)
    func getCitysLocal() -> [CityInfo]
}

class HomeInteractor: HomeInteractorProtocol {
    
    private var apiService: WeatherApiProtocol?
    private let coredataManager: CoreDataManager
    
    init(service: WeatherApiProtocol, coredataManager: CoreDataManager = CoreDataManager.init()) {
        self.apiService = service
        self.coredataManager = coredataManager
    }
    
    func search(cityName: String, successBlock: (([SearchResult]) -> ())?, failBlock: ((String) -> ())?) {
        self.apiService?.search(query: cityName, completion: { result in
            switch result {
            case .success(let searchData):
                successBlock?(searchData.results)
            case .failure(let error):
                failBlock?(error.customLocalizedDescription)
            }
        })
    }

    func getCitysLocal() -> [CityInfo] {
        return coredataManager.fetchCityList()
    }
}
