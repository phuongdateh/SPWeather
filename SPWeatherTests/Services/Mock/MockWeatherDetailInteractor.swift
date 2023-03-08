//
//  MockWeatherDetailInteractor.swift
//  SPWeatherTests
//
//  Created by James on 08/03/2023.
//

import Foundation
@testable import SPWeather

class MockWeatherDetailInteractor: WeatherDetailInteractorProtocol {
    var weatherData: WeatherData?
    var weatherIconData: Data?
    var errorMessage: String?

    func getWeather(cityName: String, success: @escaping WeatherDataAction, failure: @escaping StringAction) {
        if let weatherData = weatherData {
            success(weatherData)
        } else if let errorMessage = errorMessage {
            failure(errorMessage)
        }
    }

    func getWeatherIcon(url: String, completion: @escaping DataAction) {
        if let weatherIconData = weatherIconData {
            completion(weatherIconData)
        }
    }
}
