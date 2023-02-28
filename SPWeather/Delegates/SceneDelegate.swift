//
//  SceneDelegate.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        Application.shared.presentView(with: window)
    }
}
