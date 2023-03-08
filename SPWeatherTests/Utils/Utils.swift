//
//  XCTestCase.swift
//  SPWeatherTests
//
//  Created by phuong.doand on 05/09/2021.
//

import XCTest
import CoreData
@testable import SPWeather

class Utils {
    func loadStub(name: String, extension: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: `extension`)
        return try! Data(contentsOf: url!)
    }
}
