//
//  DiscoverScreenView.swift
//  TravelPal
//
//  Created by Alexia Aldea on 02.09.2024.
//

import SwiftUI
import Kingfisher

struct DiscoverScreenView: View {
    @EnvironmentObject private var navigation: Navigation
    private let mainNavigation = EnvironmentObjects.navigation
    @StateObject private var viewModel = DiscoverViewModel()
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Discover the city you are visiting")
                    .font(.Poppins.bold(size: 24))
                    .foregroundColor(.black)
                
                Text("Scan a monument and find out more about it! Play our mini-game to test yourself, collect points and TODO!!!!")
                    .font(.Poppins.regular(size: 12))
                    .foregroundStyle(Color.contentSecondary)
            }.padding(.top, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    StepInfoWidgetView(icon: .icStep1, text: "Take or choose a photo")
                    StepInfoWidgetView(icon: .icStep2, text: "Read the information that our smart friend, Juan, will display on the screen")
                    StepInfoWidgetView(icon: .icStep3, text: "Accept our challenge to test your knowledge")
                    StepInfoWidgetView(icon: .icStep4, text: "Collect points for each correct answer. These points will .....TODO ")
                    
                    if let image = viewModel.image {
                        HStack {
                            Spacer()
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 3)
                                .clipped()
                            Spacer()
                        }
                    }
                }.padding(.top, 32)
            }
        }.padding(.horizontal, 16)
            .safeAreaInset(edge: .bottom, content: {
                RedButtonView(text: "Start") {
                    self.showSheet = true
                }.padding(.horizontal, 16)
                    .padding(.bottom, 24)
            })
            .background(Color.bgSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .onChange(of: viewModel.image) { newValue in
                if newValue != nil {
                    self.showSheet = false
                    
                    navigation.presentPopup(LoaderView().asDestination(), animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        navigation.dismissModal(animated: true, completion: nil)
                        mainNavigation?.push(AccountScreenView().asDestination(), animated: true)
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                AddPhotoView(selectedImage: $viewModel.image,
                             hideBottomSheet: $showSheet)
            }
            .overlay {
                VStack {
                    
                }
            }
    }
}

fileprivate struct StepInfoWidgetView: View {
    let icon: ImageResource
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.Poppins.regular(size: 14))
                .foregroundStyle(Color.black)
        }
    }
}
