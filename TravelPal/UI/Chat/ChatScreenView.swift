//
//  ChatsScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 12.08.2023.
//

import SwiftUI

struct ChatScreenView: View {
    @StateObject var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 28)
            
            Spacer()
            
            ForEach(viewModel.messages) { message in
                Text("\(message.userName)")
                    .font(Poppins.SemiBold(size: 16))
                    .foregroundColor(.gray)
                
                Text("\(message.message)")
                    .font(Poppins.Regular(size: 20))
                    .foregroundColor(.black)
                    .border(.gray)
                
                HStack {
                    Spacer()
                    Text("\(message.date)")
                        .font(Poppins.SemiBold(size: 16))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

