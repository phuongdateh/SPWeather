//
//  HomeViewModelItem.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

enum HomeViewModelItem {
    case searching(SearchResult)
    case searchFail(String)
    case searchHistory(CityInfo)
}
