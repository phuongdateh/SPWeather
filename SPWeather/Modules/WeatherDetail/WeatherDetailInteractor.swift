//
//  WeatherDetailInteractor.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

protocol WeatherDetailInteractorProtocol {
    func getWeather(cityName: String, successBlock: ((WeatherData) -> ())?, failBlock: ((String) -> ())?)
    func getWeatherIcon(url: String, completion: ((Data?) ->())?)
}

class WeatherDetailInteractor: NSObject, WeatherDetailInteractorProtocol {
    private let apiService: WeatherApiProtocol
    private let coreDataManager: CoreDataManager
    
    init(apiService: WeatherApiProtocol, coreDataManager: CoreDataManager = CoreDataManager.init()) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
    }
    
    func getWeather(cityName: String,
                    successBlock: ((WeatherData) -> ())?,
                    failBlock: ((String) -> ())?) {
        apiService.getWeather(of: cityName) { result in
            switch result {
            case .success(let weatherData):
                if weatherData.cities.isEmpty == false {
                    self.saveCity(with: weatherData.cities[0].query)
                }
                successBlock?(weatherData)
            case .failure(let error):
                failBlock?(error.customLocalizedDescription)
            }
        }
    }
    
    func getWeatherIcon(url: String, completion: ((Data?) -> ())?) {
        apiService.downloadImage(url: url) { result in
            switch result {
            case .success(let data):
                completion?(data)
            case .failure(let error):
                print(error.customLocalizedDescription)
                completion?(nil)
            }
        }
    }
    
    private func saveCity(with cityName: String) {
        let cityNameList: [String] = self.coreDataManager.fetchCityList().map{( $0.name ?? "")}
        if cityNameList.contains(cityName) {
            coreDataManager.updateCity(with: cityName)
        } else {
            let _ = self.coreDataManager.insertCityItem(name: cityName)
        }
        coreDataManager.save()
    }
    
}
