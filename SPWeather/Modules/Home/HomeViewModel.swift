//
//  HomeViewModel.swift
//  HomeViewModel
//
//  Created by James on 28/02/2023.
//

import Foundation

enum HomeViewState {
    case seaching
    case empty
    case history
}

class HomeViewModel: ViewModel {
    private var interactor: HomeInteractorProtocol
    private var cityInfoList: [CityInfo]?
    
    var viewState: HomeViewState!
    var didChangeData: (([HomeViewModelItem]) -> ())?
    var currentCityList: [CityInfo]?
    
    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
        self.currentCityList = interactor.getCitysLocal()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateCityList),
                       name: NSNotification.Name(rawValue: CustomNotificationName.managedObjectContextDidSave.rawValue), object: nil)
    }
    
    func createWeatherDetailViewModel(city: String) -> WeatherDetailViewModel {
        let interactor = WeatherDetailInteractor.init(apiService: WeatherAPIService.init())
        return .init(interactor, city: city)
    }
    
    func resetViewState() {
        var viewModelItems = [HomeViewModelItem]()
        if self.interactor.getCitysLocal().isEmpty == false {
            viewModelItems = self.prepareSearchHistoryViewModelItems(self.interactor.getCitysLocal())
            self.viewState = .history
        } else {
            self.viewState = .empty
        }
        self.didChangeData?(viewModelItems)
    }
    
    func search(query: String) {
        if query.isEmpty == false {
            self.viewState = .seaching
            self.interactor.search(cityName: query, successBlock: { [weak self] results in
                if let self = self {
                    self.didChangeData?(self.prepareSearchingViewModelItems(results))
                }
            }, failBlock: { [weak self] errorMessage in
                if let self = self {
                    self.didChangeData?(self.prepareSearchFailViewModelItems(errorMessage))
                }
            })
        }
    }
    
    func prepareSearchFailViewModelItems(_ message: String) -> [HomeViewModelItem] {
        return [HomeViewModelItem.searchFail(message)]
    }
    
    func prepareSearchingViewModelItems(_ results: [SearchResult]) -> [HomeViewModelItem] {
        return results.map({ result -> HomeViewModelItem in
            return .searching(result)
        })
    }
    
    func prepareSearchHistoryViewModelItems(_ cityList: [CityInfo]) -> [HomeViewModelItem] {
        return cityList.map({ city -> HomeViewModelItem in
            return .searchHistory(city)
        })
    }
 
    func initalViewState() {
        if let cityList = self.currentCityList,
           cityList.isEmpty == false {
            self.viewState = .history
            self.didChangeData?(self.prepareSearchHistoryViewModelItems(cityList))
        } else {
            self.viewState = .empty
        }
    }
    
    @objc func updateCityList() {
        self.currentCityList = self.interactor.getCitysLocal()
        if let cityList = self.currentCityList, cityList.isEmpty == false {
            self.didChangeData?(self.prepareSearchHistoryViewModelItems(cityList))
        }
    }
}
