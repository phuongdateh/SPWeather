//
//  SearchData.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

struct SearchApiResult: Decodable {
    let searchData: SearchData
    enum CodingKeys: String, CodingKey {
        case searchData = "search_api"
    }
}

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
