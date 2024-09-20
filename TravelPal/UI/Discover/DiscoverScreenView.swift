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
                
                Text("Scan a monument and find out more about it!")
                    .font(.Poppins.regular(size: 12))
                    .foregroundStyle(Color.contentSecondary)
            }.padding(.top, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    StepInfoWidgetView(icon: .icStep1, text: "Take or choose a photo")
                    StepInfoWidgetView(icon: .icStep2, text: "Read the information that our smart friend, Juan, will display on the screen")
                    
                }.padding(.top, 32)
            }
        }.padding(.horizontal, 16)
            .safeAreaInset(edge: .bottom, content: {
                RedButtonView(text: "Start") {
                    if viewModel.user != nil {
                        self.showSheet = true
                    } else {
                        let modal = ModalChooseOptionView(title: "Error",
                                                          description: "Please login to enjoy the full experience of TravelPal app!",
                                                          topButtonText: "Enter in your account",
                                                          bottomButtonText: "Close") {
                            navigation.dismissModal(animated: true, completion: nil)
                            mainNavigation?.push(LogInScreenView().asDestination(), animated: true)
                        } onBottomButtonTapped: {
                            navigation.dismissModal(animated: true, completion: nil)
                        }
                        
                        navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                    }
                }.padding(.horizontal, 16)
                    .padding(.bottom, 24)
            })
            .background(Color.bgSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .sheet(isPresented: $showSheet) {
                AddPhotoView(selectedImage: $viewModel.image,
                             hideBottomSheet: $showSheet) {
                    viewModel.sendImage()
                }
            }
            .onReceive(viewModel.imageSendingToAPICompletion) { event in
                switch event {
                case .completed(let monumentName):
                    viewModel.image = nil
                    navigation.dismissModal(animated: true, completion: nil)
                    let vm = MonumentInfoViewModel(monumentName: monumentName)
                    navigation.push(MonumentInfoScreen(viewModel: vm).asDestination(), animated: true)
                case .error:
                    let modal = ModalChooseOptionView(title: "Error",
                                                      description: "An error occured. Please try again!",
                                                      topButtonText: "Try again") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                case .loading:
                    navigation.presentPopup(LoaderViewWithBg().asDestination(), animated: true, completion: nil)
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
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.black)
            
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.Poppins.regular(size: 14))
                .foregroundStyle(Color.black)
        }
    }
}
