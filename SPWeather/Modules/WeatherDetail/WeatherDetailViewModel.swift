//
//  WeatherDetailViewModel.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

class WeatherDetailViewModel: ViewModel {
    private let interactor: WeatherDetailInteractorProtocol
    var city: String
    var weatherData: WeatherData?
    var errorMessage: String?
    
    init(_ interactor: WeatherDetailInteractorProtocol, city: String) {
        self.interactor = interactor
        self.city = city
    }
    
    func getWeather(successBlock: ((WeatherData) -> ())?, failBlock: ((String) -> ())?) {
        interactor.getWeather(cityName: self.city, successBlock: { weatherData in
            successBlock?(weatherData)
        }, failBlock: { errorMessage in
            failBlock?(errorMessage)
        })
    }
    
    func getWeatherIcon(url: String, completion: ((Data?) ->())?) {
        interactor.getWeatherIcon(url: url) { data in
            completion?(data)
        }
    }
}
