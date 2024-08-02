//
//  ChatsScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 12.08.2023.
//

import SwiftUI

struct ChatScreenView: View {
    @StateObject var viewModel = ChatViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        if let user = viewModel.user, !user.isAnonymous {
            VStack(alignment: .leading, spacing: 0) {
                Text("Your chats")
                    .font(.Poppins.bold(size: 24))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                Color.accentMain.frame(height: 1)
                    .padding(.top, 12)
                ScrollView(showsIndicators: false) {
                    if viewModel.userCities.isEmpty {
                        Text("At the moment, you're not member of a chat. Buy a flight ticket and then come back here!")
                            .foregroundColor(Color.accentMain)
                            .font(.Poppins.regular(size: 16))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, UIScreen.main.bounds.height / 2 - 100)
                    } else {
                        
                        ForEach(viewModel.userCities, id: \.name) { city in
                            Button {
                                let destinationViewModel = ConversationViewModel(city: city.name)
                                navigation.push(ConversationScreenView(viewModel: destinationViewModel).asDestination(),
                                                animated: true)
                            } label: {
                                ChatCardView(cityName: city.name,
                                             nbPerson: city.numberOfPerson)
                            }
                        }
                    }
                }.padding(.vertical, 20)
            }.background(Color.bgSecondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            UnloggedUserView()
        }
    }
}

fileprivate struct ChatCardView: View {
    let cityName: String
    let nbPerson: Int
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(cityName)
                    .font(.Poppins.semiBold(size: 16))
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                
                HStack(spacing: 0) {
                    
                    Image("ic_itemresult_persons")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 4)
                    
                    Text("\(nbPerson)")
                        .font(.Poppins.regular(size: 14))
                        .foregroundColor(Color.contentSecondary)
                        .padding(.trailing, 16)
                }
            }
            
            Spacer()
            
            Image("ic_itemresult_arrow")
                .resizable()
                .frame(width: 24, height: 24)
            
        }.padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white)
        .padding(.horizontal, 20)
    }
}
