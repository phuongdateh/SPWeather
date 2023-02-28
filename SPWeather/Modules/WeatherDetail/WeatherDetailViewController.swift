//
//  WeatherDetailViewController.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import UIKit

class WeatherDetailViewController: ViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.bindings()
    }
    
    private func setupUI() {
        title = "Weather Detail"
        
        descLbl.numberOfLines = 0
        errorLbl.numberOfLines = 0
    }
    
    private func bindings() {
        if let viewModel = viewModel as? WeatherDetailViewModel {
            showLoading()
            viewModel.getWeather(successBlock: { [weak self] weatherData in
                if let self = self {
                    self.updateView(weatherData: weatherData, errorMessage: nil)
                }
            }, failBlock: { [weak self] errorMessage in
                if let self = self {
                    self.updateView(weatherData: nil, errorMessage: errorMessage)
                }
            })
        }
    }
    
    private func showLoading() {
        self.view.bringSubviewToFront(loadingView)
        self.loadingView.alpha = 1
    }
    
    private func hideLoading() {
        self.loadingView.alpha = 0
    }
    
    private func updateView(weatherData: WeatherData?, errorMessage: String?) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.hideLoading()
            if let model = weatherData {
                if model.currentCondition.isEmpty == false {
                    let condition = model.currentCondition[0]
                    self.humidityLbl.text = "Humidity: " + condition.humidity + "%"
                    if condition.weatherDesc.isEmpty == false {
                        self.descLbl.text = "Description: " + condition.weatherDesc[0].value
                    }
                    self.tempLbl.text = "Temp °C: " + condition.tempC
                    self.view.bringSubviewToFront(self.contentView)
                    
                    let viewModel = self.viewModel as! WeatherDetailViewModel
                    viewModel.getWeatherIcon(url: condition.weatherIconUrl[0].value, completion: { [weak self] data in
                        DispatchQueue.main.async {[weak self] in
                            if let data = data {
                                self?.weatherIconImageView.image = UIImage(data: data)
                            }
                        }
                    })
                }
            } else {
                self.errorLbl.text = errorMessage!
                self.view.bringSubviewToFront(self.errorView)
            }
        }
    }
}
