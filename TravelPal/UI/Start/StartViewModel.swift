//
//  StartViewModel.swift
//  TravelPal
//
//  Created by Alexia Aldea on 15.06.2024.
//

import Foundation

class StartViewModel: BaseViewModel {
    var userDefaultsService = UserDefaultsService.shared
    var userService = UserService.shared
    
    func isLoggedIn() -> Bool {
        return userService.isLoggedIn
    }
    
    func getOnboardingStatus() -> Bool {
        return userDefaultsService.getOnboardingStatus()
    }
}
