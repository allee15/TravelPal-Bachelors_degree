//
//  MainScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 11.08.2023.
//

import SwiftUI

struct MainScreenView: View {
    @StateObject var viewModel = MainViewModel()
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                FlightInfoScreenView()
                    .opacity(viewModel.tabBar == .home ? 1 : 0)
                
                ChatScreenView()
                    .opacity(viewModel.tabBar == .chats ? 1 : 0)
                
                AccountScreenView()
                    .opacity(viewModel.tabBar == .account ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            TabBarScreen()
                .frame(alignment: .bottom)
        }
    }
}

