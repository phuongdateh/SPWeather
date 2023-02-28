//
//  Navigator.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import UIKit

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()

    // MARK: - segues list, all app scenes
    enum Scene {
        case home(HomeViewModel)
        case weatherDetail(WeatherDetailViewModel)
    }
    
    enum Transition {
        case root(in: UIWindow)
        case push
    }
}

extension Navigator {
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .home(let viewModel):
            return HomeViewController(viewModel: viewModel,
                                      navigator: self)
        case .weatherDetail(let viewModel):
            return WeatherDetailViewController(viewModel: viewModel,
                                               navigator: self)
        }
    }
    
    func show(segue: Scene, sender: UIViewController?, transition: Transition) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            let navigationController = UINavigationController(rootViewController: target)
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = navigationController
            }, completion: nil)
            return
        case .push:
            if let navitaionController = sender?.navigationController {
                navitaionController.pushViewController(target, animated: true)
            }
        }
    }
}

