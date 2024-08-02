//
//  BottomNavBarScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 11.08.2023.
//

import SwiftUI

struct TabBarScreen: View {
    @StateObject var viewModel = TabBarViewModel()
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.setTabBar(value: .home)
            } label: {
                VStack(spacing: 4) {
                    Spacer()
                    
                    Image(systemName: "airplane")
                        .foregroundColor(viewModel.tabBar == .home ? Color.accentMain : Color.contentSecondary)
                        .frame(height: 16)
                    
                    Text("Flights")
                        .font(viewModel.tabBar == .home ? .Poppins.bold(size: 12): .Poppins.regular(size: 12))
                        .foregroundColor(viewModel.tabBar == .home ? Color.accentMain : Color.contentSecondary)
                }
                
            }.disabled(viewModel.tabBar == .home)
                .padding(.leading, 44)
            
            Spacer()
            
            Button {
                viewModel.setTabBar(value: .chats)
            } label: {
                VStack(spacing: 4) {
                    Spacer()
                    
                    Image(systemName: "message.fill")
                        .foregroundColor(viewModel.tabBar == .chats ? Color.accentMain : Color.contentSecondary)
                        .frame(height: 16)
                    
                    Text("Chats")
                        .font(viewModel.tabBar == .chats ? .Poppins.bold(size: 12): .Poppins.regular(size: 12))
                        .foregroundColor(viewModel.tabBar == .chats ? Color.accentMain : Color.contentSecondary)
                }
            }.disabled(viewModel.tabBar == .chats)
            
            Spacer()
            
            Button {
                viewModel.setTabBar(value: .account)
            } label: {
                VStack(spacing: 4) {
                    Spacer()
                    
                    Image(systemName: "person.fill")
                        .foregroundColor(viewModel.tabBar == .account ? Color.accentMain : Color.contentSecondary)
                        .frame(height: 16)
                    
                    Text("Profile")
                        .font(viewModel.tabBar == .account ? .Poppins.bold(size: 12): .Poppins.regular(size: 12))
                        .foregroundColor(viewModel.tabBar == .account ? Color.accentMain : Color.contentSecondary)
                }
            }.disabled(viewModel.tabBar == .account)
                .padding(.trailing, 44)
        }
        .padding(.top, 8)
        .frame(height: 32)
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(.white)
    }
}


