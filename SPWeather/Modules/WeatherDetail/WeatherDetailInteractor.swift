//
//  WeatherDetailInteractor.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

typealias VoidAction = () -> Void
typealias StringAction = (String) -> Void
typealias WeatherDataAction = (WeatherData) -> Void

protocol WeatherDetailInteractorProtocol {
    func getWeather(cityName: String, success: @escaping WeatherDataAction, failure: @escaping StringAction)
    func getWeatherIcon(url: String, completion: @escaping DataAction)
}

class WeatherDetailInteractor: NSObject, WeatherDetailInteractorProtocol {
    private let apiService: WeatherApiProtocol
    private let coreDataManager: CoreDataManagerInterface

    init(apiService: WeatherApiProtocol,
         coreDataManager: CoreDataManagerInterface = CoreDataManager()) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
    }
    
    func getWeather(cityName: String, success: @escaping WeatherDataAction, failure: @escaping StringAction) {
        apiService.getWeather(of: cityName) { result in
            switch result {
            case .success(let weatherData):
                if weatherData.cities.isEmpty == false {
                    self.saveCity(with: weatherData.cities[0].query)
                }
                success(weatherData)
            case .failure(let error):
                failure(error.customLocalizedDescription)
            }
        }
    }
    
    func getWeatherIcon(url: String, completion: @escaping DataAction) {
        apiService.downloadImage(url: url) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.customLocalizedDescription)
                completion(nil)
            }
        }
    }
    
    func saveCity(with cityName: String) {
        if coreDataManager.fetchCity(with: cityName) != nil {
            coreDataManager.updateCity(with: cityName)
        } else {
            let _ = coreDataManager.insertCityItem(name: cityName)
        }
        coreDataManager.save()
    }
}
