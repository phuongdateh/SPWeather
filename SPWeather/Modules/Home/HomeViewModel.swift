//
//  HomeViewModel.swift
//  HomeViewModel
//
//  Created by James on 28/02/2023.
//

import Foundation

typealias HomeViewStateAction = (HomeViewState) -> Void

enum HomeViewState {
    case searching
    case empty
    case history
}

protocol HomeViewModelInterface {
    var didUpdateViewState: HomeViewStateAction? { get set }

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
            didUpdateViewState?(self.viewState)
        }
    }
    var didUpdateViewState: HomeViewStateAction?
    lazy var currentCityList = [CityInfo]()

    // Debouncer Tool
    lazy var debouncer = Debouncer(delay: 0.5)

    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
        currentCityList.append(contentsOf: interactor.getCitysLocal())
        registerObjectContextDidSave()
    }

    func registerObjectContextDidSave(action: VoidAction? = nil) {
        interactor.registerObjectContextDidSave { [weak self] in
            self?.updateCityList()
            action?()
        }
    }

    func createWeatherDetailViewModel(city: String) -> WeatherDetailViewModel {
        let interactor = WeatherDetailInteractor(apiService: WeatherAPIService())
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
        debouncer.call(action: { [weak self] in
            self?.interactor.search(
                cityName: query,
                success: { [weak self] results in
                    self?.prepareSearchingViewModelItems(results)
                }, failure: { [weak self] errorMessage in
                    self?.prepareSearchFailViewModelItems(errorMessage)
                })
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
        viewState = .searching
    }
    
    func prepareSearchingViewModelItems(_ results: [SearchResult]) {
        viewModelItems = results.map({ result -> HomeViewModelItem in
            return .searching(result)
        })
        viewState = .searching
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

    func updateCityList() {
        currentCityList = interactor.getCitysLocal() // Get new local data after user go to Detail Screen
    }
}
