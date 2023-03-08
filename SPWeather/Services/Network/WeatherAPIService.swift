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
        urlSession.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.message("Getting data image fail")))
                return
            }
            completion(.success(data))
        }.resume()
    }

    func search(query cityName: String,
                completion: @escaping SearchDataResult) {
        guard let request = SearchRequest(query: cityName) else {
            completion(.failure(.failedRequest))
            return
        }
        urlSession.dataTask(with: request.url) { data, response, error in
            guard let data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let searchApiResult = try? JSONDecoder().decode(SearchApiResult.self, from: data) else {
                guard let error = try? JSONDecoder().decode(ErrorResult.self, from: data),
                      let msg = error.data.errors.first?.msg else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.failure(.message(msg)))
                return
            }
            completion(.success(searchApiResult.searchData))
        }.resume()
    }
    
    func getWeather(of city: String, completion: @escaping WeatherDataResult) {
        guard let request = WeatherRequest(query: city) else {
            completion(.failure(.failedRequest))
            return
        }
        self.urlSession.dataTask(with: request.url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let weatherDetailData = try? JSONDecoder().decode(WeatherDetailData.self, from: data) else {
                guard let error = try? JSONDecoder().decode(ErrorResult.self, from: data),
                      let msg = error.data.errors.first?.msg else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.failure(.message(msg)))
                return
            }
            completion(.success(weatherDetailData.data))
        }.resume()
    }
}
