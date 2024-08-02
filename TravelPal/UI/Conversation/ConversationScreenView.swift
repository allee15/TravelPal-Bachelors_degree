//
//  ConversationScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 22.08.2023.
//

import SwiftUI

struct ConversationScreenView: View {
    @ObservedObject var viewModel: ConversationViewModel
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                BackButton(imageName: "ic_nav_close")
                
                Text("Trip to \(viewModel.city)")
                    .font(.Poppins.semiBold(size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button {
                    let modal = ModalChooseOptionView(title: "Are you sure you want to leave this chat?",
                                                      description: "This action will take you out of this chat and you will not be able to enter again, unless you will buy a new flight ticket to the same destination.",
                                                      topButtonText: "Leave chat",
                                                      bottomButtonText: "Stay") {
                        viewModel.removeUserFromChat()
                        navigation.dismissModal(animated: true, completion: nil)
                        navigation.popToRoot(animated: true)
                    } onBottomButtonTapped: {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                    
                } label: {
                    Image(.icNavbarDelete)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 8)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    
                    ForEach(viewModel.messages) { message in
                        let wasSentByMe = message.email == viewModel.user?.email
                        VStack(spacing: 0) {
                            HStack(spacing: 8) {
                                if !wasSentByMe {
                                    ChatPicPlaceHolder(name: message.name)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("\(message.message)")
                                        .font(.Poppins.regular(size: 16))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("\(message.date.formatted(.dateTime))")
                                        .font(.Poppins.semiBold(size: 10))
                                        .foregroundColor(Color.contentSecondary)
                                }.padding(.all, 12)
                                    .background(wasSentByMe ? Color.contentSecondary.opacity(0.3) : Color.accentTertiary.opacity(0.3))
                                    .cornerRadius(10)
                                    .frame(width: UIScreen.main.bounds.width * 0.8, alignment: wasSentByMe ? .trailing : .leading)
                                    .id(message.id)
                                    .onChange(of: viewModel.messages.count, perform: { _ in
                                        scrollProxy.scrollTo(viewModel.messages.last?.id)
                                    })
                            }
                        }.padding(.horizontal, 8)
                            .padding(.bottom, 12)
                    }
                    
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .padding(.horizontal, 2)
                .foregroundColor(Color.contentSecondary)
            
            SendMessageField(text: $viewModel.message,
                             placeHolder: "Type your message",
                             icon: .icSend) {
                viewModel.sendMessage()
            }
                .padding(.bottom, 20)
        }.background(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
    }
}

fileprivate struct ChatPicPlaceHolder: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                    )
                
                Text(name.first?.uppercased() ?? "A")
                    .font(.Poppins.semiBold(size: 12))
                    .foregroundColor(.black)
            }
            
            Text(name)
                .font(.Poppins.semiBold(size: 12))
                .foregroundColor(.black)
        }
    }
}

fileprivate struct SendMessageField: View {
    @Binding var text: String
    var placeHolder: String
    var colors: (bgColor: Color, borderColor: Color, placeholderForeground: Color) = (.bgSecondary, .bgSecondary, .contentSecondary)
    var icon: ImageResource
    let action: () -> ()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
                    if $text.wrappedValue.isEmpty {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.Poppins.regular(size: 14))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.Poppins.regular(size: 14))
                            .scaleEffect(0.75, anchor: .leading)
                            .offset(y: -12)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    Spacer()
                }.padding(.horizontal, 16)
                
                TextField(text: $text) {
                }.foregroundColor(.black)
                    .font(.Poppins.regular(size: 14))
                    .padding(.leading, 16)
                    .offset(y: $text.wrappedValue.isEmpty ? 0 : 4 )
                    .padding(.trailing, 16)
                
                HStack {
                    Spacer()
                    Button {
                        if !text.isEmpty {
                            action()
                        }
                    } label: {
                        Image(icon)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 16)
                    }
                }
            }
            .frame(height: 54)
            .background(.white)
        }
    }
}
