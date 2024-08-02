//
//  ContentView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 03.08.2023.
//

import SwiftUI
import Firebase

struct StartScreenView: View {
    @ObservedObject var viewModel = StartViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn() {
            MainScreenView()
        } else {
            if viewModel.getOnboardingStatus() {
                LogInScreenView()
            } else {
                OnBoardingScreenView()
            }
        }
    }
}


