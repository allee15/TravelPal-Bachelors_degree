//
//  ConfirmedVacayScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 07.08.2023.
//

import SwiftUI

struct ModalScreenView: View {
    @State var depTimeUtc: String
    @State var arrName: String
    @State var countUsers: Int
    @State var action: () -> ()
    
    var body: some View {
        VStack(alignment: .center) {
            Image("check")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.bottom, 20)
                .padding(.top)
            
            Text("Congratulations! You are going on \(depTimeUtc) to \(arrName). Don't forget your passport and all the required documents!")
                .font(.Poppins.semiBold(size: 14))
                .lineLimit(4)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text("You'll be added to a chat for your destination! At the moment, there are \(countUsers) participants.")
                .bold()
                .font(.Poppins.regular(size: 12))
                .padding(.bottom, 10)
            
            Button {
                action()
            } label: {
                Text("Join the chat! >>")
                    .font(.Poppins.regular(size: 16))
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 32)
        .background(.white)
        .frame(maxWidth: .infinity)
        .transition(.move(edge: .bottom))
    }
}

