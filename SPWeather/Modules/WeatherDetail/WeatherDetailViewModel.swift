//
//  WeatherDetailViewModel.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

typealias DataAction = (Data?) -> Void
typealias ErrorMessageAction = (String) -> Void
typealias WeatherDetailViewStateAction = (WeatherDetailViewModel.ViewState) -> Void

protocol WeatherDetailViewModelInterface {
    var didUpdateViewState: WeatherDetailViewStateAction? { get set }

    func contentAttributedText() -> NSAttributedString?
    func fetchWeather()
    func downloadIcon(completion: @escaping DataAction)
}

class WeatherDetailViewModel: WeatherDetailViewModelInterface {
    private let interactor: WeatherDetailInteractorProtocol
    var didUpdateViewState: WeatherDetailViewStateAction?

    var viewState: ViewState = .loading {
        didSet {
            didUpdateViewState?(self.viewState)
        }
    }

    let city: String
    var weatherData: WeatherData?
    var errorMessage: String?
    
    init(_ interactor: WeatherDetailInteractorProtocol,
         city: String) {
        self.city = city
        self.interactor = interactor
    }

    func fetchWeather() {
        viewState = .loading
        interactor.getWeather(
            cityName: city,
            success: { [weak self] response in
                self?.weatherData = response
                self?.viewState = .loaded
        }, failure: { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.viewState = .loaded
        })
    }

    func downloadIcon(completion: @escaping DataAction) {
        guard let url = weatherData?.currentCondition.first?.weatherIconUrl.first?.value else {
            completion(nil)
            return
        }
        interactor.getWeatherIcon(url: url) { data in
            completion(data)
        }
    }

    func contentAttributedText() -> NSAttributedString? {
        guard let errorMessage = errorMessage else {
            return detailWeatherAttributedText
        }
        return NSAttributedString(string: errorMessage)
    }

    var detailWeatherAttributedText: NSAttributedString? {
        guard let weatherData = weatherData,
              !weatherData.currentCondition.isEmpty,
              let condition = weatherData.currentCondition.first else {
            return nil
        }
        let results = NSMutableAttributedString()
        results.append(NSAttributedString(string: "Humidity: " + condition.humidity + "%" + "\n"))
        results.append(NSAttributedString(string: "Description: \(condition.weatherDesc.first?.value ?? "")" + "\n"))
        results.append(NSAttributedString(string: "Temp °C: " + condition.tempC))
        return results
    }

    enum ViewState {
        case loading
        case loaded
    }
}
