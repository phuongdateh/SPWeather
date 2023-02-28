//
//  SearchData.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

struct SearchData: Decodable {
    enum CodingKeys: String, CodingKey {
        case results = "result"
    }
    
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let areaName: [Value]
    let country: [Value]
    let region: [Value]
    let latitude: String
    let longitude: String
    let population: String
    let weatherUrl: [Value]
    
    struct Value: Decodable {
        let value: String
    }
}
