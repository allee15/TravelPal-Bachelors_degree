//
//  AppNavigationBar.swift
//  TravelPal
//
//  Created by Aldea Alexia on 11.08.2023.
//

import Foundation
import Combine

enum NavTabs {
    case home
    case chats
    case account
}

class AppNavigationBarService {
    var tabBar: CurrentValueSubject<NavTabs, Never> = .init(.home)
    static let shared = AppNavigationBarService()
    
    private init() { }
}
