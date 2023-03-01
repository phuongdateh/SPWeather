//
//  WeatherData.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

struct WeatherData: Decodable {
    let cities: [City]
    let currentCondition: [CurrentCondition]

    init(cities: [City],
         currentCondition: [CurrentCondition]) {
        self.cities = cities
        self.currentCondition = currentCondition
    }
}

extension WeatherData {
    enum CodingKeys: String, CodingKey {
        case cities = "request"
        case currentCondition = "current_condition"
    }
    
    // Request Response
    struct City: Decodable {
        let type: String
        let query: String
    }
}
