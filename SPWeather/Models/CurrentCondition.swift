//
//  CurrentCondition.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

struct CurrentCondition: Decodable {
    let humidity: String
    let tempC: String
    let tempF: String
    let weatherIconUrl: [Value]
    let weatherDesc: [Value]
    
    enum CodingKeys: String, CodingKey {
        case humidity
        case tempC = "temp_C"
        case tempF = "temp_F"
        case weatherIconUrl
        case weatherDesc
    }
    
    struct Value: Decodable {
        let value: String
    }
}
