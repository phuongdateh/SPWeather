//
//  HomeViewModel.swift
//  HomeViewModel
//
//  Created by James on 28/02/2023.
//

import Foundation

typealias VoidAction = () -> Void

enum HomeViewState {
    case seaching
    case empty
    case history
}

protocol HomeViewModelInterface {
    var didChangeData: VoidAction? { get set }
    var viewState: HomeViewState! { get set }

    func initalViewState()
    func resetViewState()
    func createWeatherDetailViewModel(city: String) -> WeatherDetailViewModel
    func search(query: String)

    func numberOfRowsInSection() -> Int
    func dataForCell(at indexPath: IndexPath) -> HomeViewModelItem?
}

class HomeViewModel: HomeViewModelInterface {
    private var interactor: HomeInteractorProtocol
    private var cityInfoList: [CityInfo]?
    
    var viewState: HomeViewState!
    var didChangeData: VoidAction?
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
//        var viewModelItems = [HomeViewModelItem]()
        guard !interactor.getCitysLocal().isEmpty else {
            viewState = .empty
            didChangeData?()
            return
        }
        prepareSearchHistoryViewModelItems(interactor.getCitysLocal())
        viewState = .history
        didChangeData?()
//        if interactor.getCitysLocal().isEmpty == false {
////            viewModelItems = prepareSearchHistoryViewModelItems(self.interactor.getCitysLocal())
//            prepareSearchHistoryViewModelItems(interactor.getCitysLocal())
//        viewState = .history
//        } else {
//            viewState = .empty
//        }
    }

    func search(query: String) {
        guard !query.isEmpty else { return }
        viewState = .seaching
        interactor.search(cityName: query, successBlock: { [weak self] results in
            self?.prepareSearchingViewModelItems(results)
//            self.didChangeData?(self.prepareSearchingViewModelItems(results))
            self?.didChangeData?()
        }, failBlock: { [weak self] errorMessage in
//            guard let self = self else { return }
//            self.didChangeData?(self.prepareSearchFailViewModelItems(errorMessage))
            self?.prepareSearchFailViewModelItems(errorMessage)
            self?.didChangeData?()
        })
    }

    lazy var viewModelItems = [HomeViewModelItem]()

    func numberOfRowsInSection() -> Int {
        return viewModelItems.count
    }

    func dataForCell(at indexPath: IndexPath) -> HomeViewModelItem? {
        guard viewModelItems.count > indexPath.row else {
            return nil
        }
        return viewModelItems[indexPath.row]
    }

    func prepareSearchFailViewModelItems(_ message: String) {
        viewModelItems = [HomeViewModelItem.searchFail(message)]
    }
    
    func prepareSearchingViewModelItems(_ results: [SearchResult]) {
        viewModelItems = results.map({ result -> HomeViewModelItem in
            return .searching(result)
        })
    }

    func prepareSearchHistoryViewModelItems(_ cityList: [CityInfo]) {
        viewModelItems = cityList.map({ city -> HomeViewModelItem in
            return .searchHistory(city)
        })
    }
 
    func initalViewState() {
        if let cityList = self.currentCityList,
           cityList.isEmpty == false {
            self.viewState = .history
//            self.didChangeData?(self.prepareSearchHistoryViewModelItems(cityList))
            prepareSearchHistoryViewModelItems(cityList)
            didChangeData?()
        } else {
            viewState = .empty
        }
    }
    
    @objc func updateCityList() {
        self.currentCityList = self.interactor.getCitysLocal()
        if let cityList = self.currentCityList,
           cityList.isEmpty == false {
//            self.didChangeData?(self.prepareSearchHistoryViewModelItems(cityList))
            prepareSearchHistoryViewModelItems(cityList)
            didChangeData?()
        }
    }
}
