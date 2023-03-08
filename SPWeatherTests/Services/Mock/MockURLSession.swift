//
//  MockURLSession.swift
//  SPWeatherTests
//
//  Created by James on 08/03/2023.
//

import Foundation

class MockURLSession {
    var urlSession: URLSession!
    lazy var configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return configuration
    }()

    init() {
        urlSession = URLSession(configuration: configuration)
    }

    func getSession() -> URLSession {
        return urlSession
    }

    func setupResponseData(_ data: Data) {
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
    }

    func setupErrorResponse() {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "http://cdn.worldweatheronline.com")!,
                                           statusCode: 400,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, Data(count: 11))
        }
    }
}
