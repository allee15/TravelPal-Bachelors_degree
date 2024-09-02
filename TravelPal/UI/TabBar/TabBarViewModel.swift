//
//  BottomBarViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 11.08.2023.
//

import Foundation
import Combine

enum NavTabs: Equatable {
    case home
    case chats
    case discover
    case account
}

class TabBarViewModel: BaseViewModel {
    @Published var tabBar: NavTabs = .home
    public var oldTabBar: NavTabs = .home
    
}
