//
//  BottomBarViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 11.08.2023.
//

import Foundation
import SwiftUI
import Combine

class TabBarViewModel: BaseViewModel {
    @Published var tabBar: NavTabs = .home
    let appNavigationBarService = AppNavigationBarService.shared
    
    override init() {
        super.init()
        appNavigationBarService.tabBar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.tabBar = value
            }
            .store(in: &bag)
    }
    
    func setTabBar(value: NavTabs) {
        appNavigationBarService.tabBar.value = value
    }
}
