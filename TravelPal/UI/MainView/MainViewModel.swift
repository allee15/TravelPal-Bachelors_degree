//
//  MainViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 11.08.2023.
//

import Foundation
import SwiftUI

class MainViewModel: BaseViewModel {
    @Published var tabBar: NavTabs = .home
    
    override init() {
        super.init()
        
        AppNavigationBarService.shared.tabBar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.tabBar = value
            }
            .store(in: &bag)
    }
}
