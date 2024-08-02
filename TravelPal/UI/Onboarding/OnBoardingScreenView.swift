//
//  OnBoardingScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 10.08.2023.
//

import SwiftUI

struct OnBoardingScreenView: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject var viewModel = OnBoardingViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("logo_app1")
                .resizable()
                .frame(width: 153, height: 27)
                .padding(.bottom, 44)
                .padding(.top, 24)
                .padding(.horizontal, 16)
            
            Text("Meet and Explore with TravelPal")
                .font(.Poppins.bold(size: 28))
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            
            Text("Join conversations with fellow travelers who share your passion for your dream holiday destination")
                .font(.Poppins.regular(size: 14))
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 24)
                .padding(.horizontal, 16)
            
            ZStack {
                Image("bg-onboarding")
                    .resizable()
                
                VStack(spacing: 12) {
                    Spacer()
                    
                    RedButtonView(text: "Access my TravelPal Account") {
                        viewModel.userDefaultsService.setOnboarding(onboardingIsOver: true)
                        navigation.push(LogInScreenView().asDestination(), animated: true)
                    }
                    
                    BlackButtonView(text: "Continue as Guest") {
                        viewModel.userDefaultsService.setOnboarding(onboardingIsOver: true)
                        navigation.replaceNavigationStack([MainScreenView().asDestination()], animated: true)
                    }
                }.padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }.background(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

