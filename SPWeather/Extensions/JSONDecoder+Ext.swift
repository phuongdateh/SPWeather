//
//  JSONDecoder+Ext.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

extension JSONDecoder {
    func map<T: Decodable>(_ type: T.Type, from dict: [String: Any]) -> T? {
        if let data = dict.data {
            do {
                let object = try decode(T.self, from: data)
                return object
            } catch {
                return nil
            }
        }
        return nil
    }
}

extension Dictionary {
    var data: Data? {
        get {
            return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        }
    }
}
