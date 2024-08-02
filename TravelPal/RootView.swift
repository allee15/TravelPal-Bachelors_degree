//
//  TravelPalApp.swift
//  TravelPal
//
//  Created by Aldea Alexia on 03.08.2023.
//

import SwiftUI
import FirebaseAuth
import Firebase

class RootViewModel: BaseViewModel {
    
    private var isBinded = false
      
    func bind() {
        if isBinded {return}
        isBinded = true
    }
}

struct RootView: View {
    @ObservedObject var navigation: Navigation
    @StateObject private var viewModel = RootViewModel()
    @StateObject private var toastManager = ToastManager()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationHostView(navigation: navigation)
                .onAppear {
                    viewModel.bind()
                    ToastManager.instance = toastManager
                }
                .overlay(
                    VStack {
                        if let toast = toastManager.toast {
                            ToastView(toast: toast)
                                .padding(SafeAreaInsets)
                                .padding(.top, 24)
                                .transition(.move(edge: .top))
                                .onTapGesture {
                                    toastManager.hideToast()
                                }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onEnded({ value in
                                        if value.translation.height < 0 {
                                            toastManager.hideToast()
                                        }
                                    }))
                        }
                        Spacer()
                    }
                        .ignoresSafeArea()
                        .animation(.easeIn(duration: 0.25), value: toastManager.toast)
                )
        }.ignoresSafeArea()
    }
    
}
