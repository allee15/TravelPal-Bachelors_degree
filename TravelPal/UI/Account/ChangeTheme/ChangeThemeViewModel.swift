//
//  ChangeThemeViewModel.swift
//  TravelPal
//
//  Created by Alexia Aldea on 02.09.2024.
//

import Combine
import UIKit

enum ThemeType: String, CaseIterable {
    case light
    case dark
    case system
}

enum ChangeThemeState {
    case completed
}

class ChangeThemeViewModel: BaseViewModel {
    private var userDefaultsService = UserDefaultsService.shared
    let themeCompletion = PassthroughSubject<ChangeThemeState, Never>()
    
    @Published var isLightModeSelected: Bool?
    @Published var isDarkModeSelected: Bool?
    @Published var isSystemModeSelected: Bool?
    
    override init() {
        super.init()
        loadThemePreference()
    }
    
    func loadThemePreference() {
        let key: Key<String> = Key(value: UserDefaultsKeys.appTheme)
        let storedTheme = userDefaultsService.getValue(key: key)
        
        self.isLightModeSelected = storedTheme == "light"
        self.isDarkModeSelected = storedTheme == "dark"
        self.isSystemModeSelected = storedTheme == "system"
        
        if let storedTheme = storedTheme, let themeType = ThemeType(rawValue: storedTheme) {
            applyThemeBasedOnPreference(theme: themeType)
        } else {
            applyThemeBasedOnPreference(theme: .system)
        }
    }
    
    func applyThemeBasedOnPreference(theme: ThemeType) {
        let key: Key<String> = Key(value: UserDefaultsKeys.appTheme)
        
        switch theme {
        case .light:
            userDefaultsService.setValue(key: key, value: "light")
            self.isLightModeSelected = true
            self.isDarkModeSelected = false
            self.isSystemModeSelected = false
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        case .dark:
            userDefaultsService.setValue(key: key, value: "dark")
            self.isLightModeSelected = false
            self.isDarkModeSelected = true
            self.isSystemModeSelected = false
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        case .system:
            userDefaultsService.setValue(key: key, value: "system")
            self.isLightModeSelected = false
            self.isDarkModeSelected = false
            self.isSystemModeSelected = true
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
        }
    }
}
