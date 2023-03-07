//
//  WeatherAPI.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

typealias WeatherDataResult = (Result<WeatherData, ErrorData>) -> ()
typealias SearchDataResult = (Result<SearchData, ErrorData>) -> ()
typealias ResultImage = (Result<Data, ErrorData>) -> ()
typealias SearchResultsAction = ([SearchResult]) -> Void

protocol WeatherApiProtocol {
    func search(query cityName: String, completion: @escaping SearchDataResult)
    func getWeather(of city: String, completion: @escaping WeatherDataResult)
    func downloadImage(url: String, completion: @escaping ResultImage)
}
