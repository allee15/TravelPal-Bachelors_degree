//
//  AppDelegate.swift
//  TravelPal
//
//  Created by Ovidiu Stoica on 17.08.2023.
//

import Foundation
import UIKit
import Firebase
import Stripe
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        NFX.sharedInstance().start()
//        STPPaymentConfiguration.shared().publishableKey = "sk_test_51NzPkBFsUJrHtrhWlwiD8MCBEZKKA22zr0rM0PCOo5XU7EUxReZlRMhlNhqan199k8Z3eObxScKdgVod1dNGarpM00OzSUewgH"
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
