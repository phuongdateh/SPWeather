//
//  ErrorData.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

enum ErrorData: Error, Equatable {
    case message(String)
    case failedRequest
    case invalidResponse
}

extension ErrorData {
    var customLocalizedDescription: String {
        get {
            switch self {
            case .message(let msg):
                return msg
            default:
                return self.localizedDescription
            }
        }
    }
}
