//
//  MonumentInfoScreen.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import SwiftUI

struct MonumentInfoScreen: View {
    @StateObject var viewModel: MonumentInfoViewModel
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                BackButton {
                    navigation.pop(animated: true)
                }
                
                Spacer()
            }.padding(.horizontal, 16)
                .padding(.top, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Hi, my name is Juan! I'm here to guide you through your trip. Here is the information that you have asked for:")
                        .foregroundStyle(Color.black)
                        .font(.Poppins.regular(size: 14))
                        .multilineTextAlignment(.leading)
                    
                    switch viewModel.monumentInfoState {
                    case .failure(_):
                        ErrorView(title: "There was an error with retrieving the data.")
                        
                    case .loading:
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                LoaderView()
                                Spacer()
                            }
                            Spacer()
                        }
                        
                    case .value(let monument):
                        VStack(alignment: .leading, spacing: 12) {
                            Text(monument.title)
                                .foregroundStyle(Color.black)
                                .font(.Poppins.semiBold(size: 20))
                                
                            Text(monument.description)
                                .foregroundStyle(Color.contentSecondary)
                                .font(.Poppins.regular(size: 14))
                            
                            Text(monument.extract)
                                .foregroundStyle(Color.black)
                                .font(.Poppins.regular(size: 14))
                            
                            Group {
                                Text("For more information, please click ") +
                                Text(.init("[here.](\(monument.link))"))
                                    .underline()
                            }.foregroundStyle(Color.black)
                                .font(.Poppins.regular(size: 14))
                                .tint(Color.black)
                        }
                    }
                }.padding(.top, 20)
                    .padding(.horizontal, 16)
            }
        }.background(Color.bgSecondary)
        .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                ToastManager.instance.show(
                    Toast(
                        text: "Monument identified successfully!",
                        textColor: Color.accentTertiary
                    ))
            }
    }
}
