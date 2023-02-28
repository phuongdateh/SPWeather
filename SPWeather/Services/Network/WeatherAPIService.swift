//
//  WeatherAPIService.swift
//  WeatherAPIService
//
//  Created by James on 28/02/2023.
//

import Foundation

final class WeatherAPIService: WeatherApiProtocol {
    
    var urlSession: URLSession!
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func downloadImage(url: String, completion: @escaping ResultImage) {
        if let url = URL.init(string: url) {
            urlSession.dataTask(with: url) { data, response, error in
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200 {
                    completion(.success(data))
                } else {
                    completion(.failure(.failedRequest))
                }
            }.resume()
        }
    }
    
    func search(query cityName: String, completion: @escaping SearchDataResult) {
        guard let request = SearchRequest(query: cityName) else {
            completion(.failure(.failedRequest))
            return
        }
        urlSession.dataTask(with: request.url) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let searchJson = json["search_api"] as? [String: Any],
                   let searchData = self.parseSearchData(searchJson) {
                    completion(.success(searchData))
                } else if let errorJson = json["data"] as? [String: Any],
                          let errorData = self.parseErrorData(errorJson) {
                    completion(.failure(.message(errorData.errors[0].msg)))
                } else {
                    completion(.failure(.invalidResponse))
                }
            } else {
                completion(.failure(.failedRequest))
            }
        }.resume()
    }
    
    func getWeather(of city: String, completion: @escaping WeatherDataResult) {
        guard let request = WeatherRequest(query: city) else {
            completion(.failure(.failedRequest))
            return
        }
        self.urlSession.dataTask(with: request.url) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let dataJson = json["data"] as? [String: Any] {
                if let weatherData = self.parseWeatherData(dataJson) {
                    completion(.success(weatherData))
                } else if let errorData = self.parseErrorData(dataJson) {
                    completion(.failure(.message(errorData.errors[0].msg)))
                } else {
                    completion(.failure(.invalidResponse))
                }
            } else {
                completion(.failure(.failedRequest))
            }
        }.resume()
    }
    
    func parseSearchData(_ dataJson: [String: Any]) -> SearchData? {
        return JSONDecoder().map(SearchData.self, from: dataJson)
    }
    
    func parseWeatherData(_ dataJson: [String: Any]) -> WeatherData? {
        return JSONDecoder().map(WeatherData.self, from: dataJson)
    }
    
    func parseErrorData(_ dataJson: [String: Any]) -> ErrorResponse? {
        return JSONDecoder().map(ErrorResponse.self, from: dataJson)
    }
}
