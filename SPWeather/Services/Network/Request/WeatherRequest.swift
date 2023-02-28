//
//  WeatherRequest.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

final class WeatherRequest {
    var url: URL
    
    init?(query: String,
          urlString: String = Configs.NetWork.baseURL) {
        if query.isEmpty == false,
           let baseURL = URL(string: "\(urlString)weather.ashx") {
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
            components.queryItems = [
                URLQueryItem(name: "key", value: Configs.NetWork.apiKey),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "num_of_days", value: "12"),
                URLQueryItem(name: "tp", value: "3"),
                URLQueryItem(name: "format", value: "json")
            ]
            self.url = components.url!
        } else {
            return nil
        }
    }
}
