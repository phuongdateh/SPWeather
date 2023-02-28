//
//  SearchRequest.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

final class SearchRequest {
    var url: URL
    
    init?(query: String) {
        if let baseURL = URL(string: "\(Configs.NetWork.baseURL)search.ashx"),
           query.isEmpty == false {
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
            components.queryItems = [
                URLQueryItem(name: "key", value: Configs.NetWork.apiKey),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "num_of_results", value: "10"),
                URLQueryItem(name: "format", value: "json")
            ]
            self.url = components.url!
        } else {
            return nil
        }
    }
}
