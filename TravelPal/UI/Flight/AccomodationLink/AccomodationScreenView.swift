//
//  AccomodationRecomandationsScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 07.08.2023.
//

import SwiftUI
import PDFKit

struct AccomodationScreenView: View {
    @ObservedObject var viewModel: AccomodationViewModel
    @EnvironmentObject private var navigation: Navigation
    @State var showModal: Bool = false
    @State private var documentInteractionController: UIDocumentInteractionController?

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                if let verifiedImage = viewModel.image {
                    let _ = print("da")
                    HStack(spacing: 12) {
                        Spacer()
                        
                        ShareLink(item: verifiedImage, preview: SharePreview("flight_ticket", image: verifiedImage)) {
                            Image(.icShare)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }
                    }.padding(.top, 24)
                        .padding(.horizontal, 16)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Congratulations! You have your trip confirmed! Now it's time to join the chat. In the next part, you will find some accomodations recommandations. Enter the link below for more available options. Choosing a hotel it's optional, you can do this later from any website you want.")
                            .font(.Poppins.regular(size: 14))
                            .foregroundColor(.black)
                        
                        Text("Note that in order to access the available chat for your trip, you have to press the button below!")
                            .font(.Poppins.semiBold(size: 14))
                            .foregroundColor(.black)
                        
                        Button {
                            viewModel.openAirBnb()
                        } label: {
                            Group {
                                Text("For more options, please click ") +
                                Text("here")
                                    .underline()
                            }
                            .font(.Poppins.semiBold(size: 14))
                            .tint(Color.black)
                        }
                    }.padding(.all, 12)
                        .background(.white)
                        .shadow(color: .bgSecondary, radius: 3)
                        .padding(.top, 32)
                        .padding(.bottom, 12)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.hotels, id: \.self) { hotel in
                                Image(hotel)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: UIScreen.main.bounds.width - 40)
                            }
                        }
                    }.padding(.bottom, 32)
                }
                
                Spacer()
            }.background(Color.bgSecondary)
            
            VStack(spacing: 0) {
                Spacer(minLength: 24)
                RedButtonView(text: "Join chat") {
                    showModal.toggle()
                }.padding(.bottom, 24)
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            ToastManager.instance?.show(
                Toast(
                    text: "Payment successful!",
                    textColor: Color.accentTertiary
                ))
        }
        .sheet(isPresented: $showModal) {
            ModalChooseOptionView(title: "Your trip is confirmed!",
                                  description: "Now, all you have to do is to press the button below in order to join the chat. Have a safe and an amazing trip! Thank you for choosing to travel with us.❤️", topButtonText: "Go to chat") {
                viewModel.updateUser()
                viewModel.addUser()
                viewModel.addChat()
                navigation.popToRoot(animated: false)
                AppNavigationBarService.shared.tabBar.value = .chats
            }
        }
    }
}

