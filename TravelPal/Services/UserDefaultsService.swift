//
//  UserDefaultsService.swift
//  TravelPal
//
//  Created by Aldea Alexia on 21.08.2023.
//

import Foundation

enum UserDefaultsKeys {
    static let hasOnboardingCompleted = "onboardingIsOver"
    static let appTheme = "appTheme"
}

public struct Key<T> {
    let value: String
}

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let defaults: UserDefaults
    
    private init() {
        defaults = UserDefaults.standard
    }
    
    func setOnboarding(onboardingIsOver: Bool) {
        defaults.set(onboardingIsOver, forKey: UserDefaultsKeys.hasOnboardingCompleted)
    }
    
    func getOnboardingStatus() -> Bool {
        defaults.bool(forKey: UserDefaultsKeys.hasOnboardingCompleted)
    }
    
    func setValue<T>(key: Key<T>, value: Optional<T>) {
        defaults.set(value, forKey: key.value) 
    }
    
    func getValue<T>(key: Key<T>) -> Optional<T> {
        return defaults.object(forKey: key.value) as? T
    }
}
