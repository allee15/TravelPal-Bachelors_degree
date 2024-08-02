//
//  UnloggedUserView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 18.01.2024.
//

import SwiftUI

struct UnloggedUserView: View {
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 48) {
            HStack(spacing: 0) {
                Image("logo_app")
                    .resizable()
                    .frame(width: 142, height: 24)
                
                Spacer()
            }.padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .background(Color.accentMain)
            
            Text("Please login to enjoy the full experience of TravelPall app!")
                .foregroundColor(.black)
                .font(.Poppins.regular(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                navigation.push(LogInScreenView().asDestination(), animated: true)
            } label: {
                Text("Enter in your account")
                    .font(.Poppins.bold(size: 14))
                    .padding(.all, 12)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
            }.padding(.bottom, 20)
                .padding(.horizontal, 20)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgSecondary)
    }
}
