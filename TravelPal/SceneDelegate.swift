//
//  SceneDelegate.swift
//  TravelPal
//
//  Created by Ovidiu Stoica on 17.08.2023.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
      
    private let navigation = Navigation(
        root: ControllerRepresentable(controller: UIStoryboard(name: "LaunchScreen", bundle: .main).instantiateInitialViewController()!)
            .ignoresSafeArea()
            .asDestination()
    )
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        EnvironmentObjects.navigation = navigation
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: RootView(navigation: navigation))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

