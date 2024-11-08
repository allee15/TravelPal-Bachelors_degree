//
//  AccomodationRecomandationsScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 07.08.2023.
//

import SwiftUI
import PDFKit
import Kingfisher

struct AccomodationScreenView: View {
    @ObservedObject var viewModel: AccomodationViewModel
    @EnvironmentObject private var navigation: Navigation
    @State var showModal: Bool = false
    @State private var documentInteractionController: UIDocumentInteractionController?

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                if let verifiedImage = viewModel.image {
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
                                Text("here.")
                                    .underline()
                            }
                            .font(.Poppins.semiBold(size: 14))
                            .tint(Color.black)
                        }
                    }.padding(.all, 12)
                        .background(.white)
                        .shadow(color: .bgSecondary, radius: 3)
                        .padding(.top, 32)
                        .padding(.horizontal, 16)
                    
                    switch viewModel.propertiesState {
                    case .failure(_):
                        EmptyView()
                        
                    case .loading:
                        VStack {
                            Spacer()
                            LoaderView()
                            Spacer()
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.bgSecondary)
                        
                    case .value(let properties):
                        ForEach(properties, id: \.id) { property in
                            HotelWidgetView(hotel: property) {
                                viewModel.openAirBnb()
                            }
                        }
                    }
                }.padding(.bottom, 28)
            }.background(Color.bgSecondary)
            
            VStack(spacing: 0) {
                Spacer(minLength: 24)
                RedButtonView(text: "Join chat") {
                    showModal.toggle()
                }.padding(.bottom, 24)
                .padding(.horizontal, 16)
            }
        }.ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            ToastManager.instance.show(
                Toast(
                    text: "Payment successful!",
                    textColor: Color.accentTertiary
                ))
        }
        .onChange(of: showModal) { newValue in
            if newValue {
                let modal = ModalChooseOptionView(title: "Your trip is confirmed!",
                                                  description: "Now, all you have to do is to press the button below in order to join the chat. Have a safe and an amazing trip! Thank you for choosing to travel with us.❤️", topButtonText: "Go to chat") {
                                viewModel.updateUser()
                                viewModel.addUser()
                                viewModel.addChat()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    navigation.dismissModal(animated: true, completion: nil)
                                    navigation.popToRoot(animated: false)
                                    TabBarCoordinator.instance.tabBarNavigation = .chats
                                }
                            }
                
                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
            }
        }
    }
}

struct HotelWidgetView: View {
    let hotel: Property
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    Text(hotel.title)
                        .foregroundStyle(Color.black)
                        .font(.Poppins.semiBold(size: 20))
                    Spacer()
                    Text(hotel.price)
                        .foregroundStyle(Color.black)
                        .font(.Poppins.regular(size: 14))
                }
                
                KFImage(URL(string: hotel.image))
                    .resizable()
                    .centerCropped()
                    .aspectRatio(16/9, contentMode: .fit)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(.white)
            .padding(.horizontal, 16)
        }
    }
}
