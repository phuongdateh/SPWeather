//
//  WeatherApiServiceMock.swift
//  SPWeatherTests
//
//  Created by James on 01/03/2023.
//

import Foundation
@testable import SPWeather

class WeatherApiServiceMock: WeatherApiProtocol {
    var weatherData: WeatherData?
    var searchData: SearchData?
    var imageData: Data?

    func search(query cityName: String, completion: @escaping SearchDataResult) {
        guard let searchData = searchData else {
            completion(.failure(.message("Failure data")))
            return
        }
        completion(.success(searchData))
    }
    
    func getWeather(of city: String, completion: @escaping WeatherDataResult) {
        guard let weatherData = weatherData else {
            completion(.failure(.message("Failure data")))
            return
        }
        completion(.success(weatherData))
    }
    
    func downloadImage(url: String, completion: @escaping ResultImage) {
        guard let imageData = imageData else {
            completion(.failure(.message("Failure data")))
            return
        }
        completion(.success(imageData))
    }
}
