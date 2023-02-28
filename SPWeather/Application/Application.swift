//
//  Application.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import UIKit

final class Application: NSObject {
    
    static let shared = Application()
    
    private var window: UIWindow?
    private var provider: WeatherApiProtocol?
    private let navigator: Navigator
    
    override init() {
        self.navigator = Navigator.default
        self.provider = WeatherAPIService()
        super.init()
    }
    
    func presentView(with window: UIWindow?) {
        guard let window = window,
              let provider = provider else { return }
        self.window = window
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let weakSelf = self else { return }
            let interactor = HomeInteractor(service: provider)
            let viewModel = HomeViewModel(interactor: interactor)
            weakSelf.navigator.show(segue: .home(viewModel), sender: nil, transition: .root(in: window))
        })
    }
}
