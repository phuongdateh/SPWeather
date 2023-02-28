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
    var didUpdateViewState: VoidAction? { get set }
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

    var viewState: HomeViewState! {
        didSet {
            didUpdateViewState?()
        }
    }
    var didUpdateViewState: VoidAction?
    lazy var currentCityList = [CityInfo]()
    
    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
        currentCityList.append(contentsOf: interactor.getCitysLocal())
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateCityList),
                       name: NSNotification.Name(rawValue: CustomNotificationName.managedObjectContextDidSave.rawValue), object: nil)
    }
    
    func createWeatherDetailViewModel(city: String) -> WeatherDetailViewModel {
        let interactor = WeatherDetailInteractor.init(apiService: WeatherAPIService.init())
        return WeatherDetailViewModel(interactor, city: city)
    }
    
    func resetViewState() {
        guard !interactor.getCitysLocal().isEmpty else {
            viewState = .empty
            return
        }
        prepareSearchHistoryViewModelItems(interactor.getCitysLocal())
        viewState = .history
    }

    func search(query: String) {
        guard !query.isEmpty else { return }
        interactor.search(cityName: query, successBlock: { [weak self] results in
            self?.prepareSearchingViewModelItems(results)
        }, failBlock: { [weak self] errorMessage in
            self?.prepareSearchFailViewModelItems(errorMessage)
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
        viewState = .seaching
    }
    
    func prepareSearchingViewModelItems(_ results: [SearchResult]) {
        viewModelItems = results.map({ result -> HomeViewModelItem in
            return .searching(result)
        })
        viewState = .seaching
    }

    func prepareSearchHistoryViewModelItems(_ cityList: [CityInfo]) {
        viewModelItems = cityList.map({ city -> HomeViewModelItem in
            return .searchHistory(city)
        })
        viewState = .history
    }
 
    func initalViewState() {
        guard !currentCityList.isEmpty else {
            viewState = .empty
            return
        }
        prepareSearchHistoryViewModelItems(currentCityList)
        viewState = .history
    }

    @objc func updateCityList() {
        currentCityList = interactor.getCitysLocal() // Get new local data after user go to Detail Screen
        guard !currentCityList.isEmpty else { return }
        prepareSearchHistoryViewModelItems(currentCityList)
        viewState = .history
    }
}
