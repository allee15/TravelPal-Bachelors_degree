//
//  TravelPalApp.swift
//  TravelPal
//
//  Created by Aldea Alexia on 03.08.2023.
//

import SwiftUI
import FirebaseAuth
import Firebase
import Combine

enum RootViewModelEvent {
    case goToTabBar
    case goToLogin
    case goToOnboarding
}

class RootViewModel: BaseViewModel {
    private var userDefaultsService = UserDefaultsService.shared
    private var userService = UserService.shared
    
    @Published var showBlockingError: Bool = false
    @Published var isLoadingBinding: Bool = false
    
    let eventSubject = PassthroughSubject<RootViewModelEvent, Never>()
    private var isBinded = false
    
    override init() {
        super.init()
        setupErrorHandling()
    }
    
    func bind() {
        showBlockingError = false
        
        guard !isBinded else {return}
        isBinded = true
        
        if userService.isLoggedIn {
            self.eventSubject.send(.goToTabBar)
        } else {
            if userDefaultsService.getOnboardingStatus() {
                self.eventSubject.send(.goToTabBar)
            } else {
                self.eventSubject.send(.goToOnboarding)
            }
        }
    }
    
    func setupErrorHandling() {
        noInternetInterceptor.errors()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorEvent in
                guard let self else {return}
                self.showBlockingError = true
            }
            .store(in: &bag)
    }
    
    func retryBinding() {
        showBlockingError = false
        isLoadingBinding = true
        
        bind()
    }
}

struct RootView: View {
    private let mainNavigation = EnvironmentObjects.navigation
    let navigation: Navigation
    
    @StateObject private var viewModel = RootViewModel()
    @ObservedObject private var toastManager = ToastManager.instance
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationHostView(navigation: navigation)
                .onReceive(viewModel.eventSubject, perform: { event in
                    switch event {
                    case .goToTabBar:
                        navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
                    case .goToLogin:
                        navigation.replaceNavigationStack([LogInScreenView().asDestination()], animated: true)
                    case .goToOnboarding:
                        navigation.push(OnBoardingScreenView().asDestination(), animated: true)
                    }
                })
                .onAppear {
                    viewModel.bind()
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
