//
//  LogInScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 09.08.2023.
//

import SwiftUI
import Kingfisher

struct LogInScreenView: View {
    @StateObject var viewModel = LogInViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavBarView(isCloseButton: true)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Access your TravelPal account")
                        .font(.Poppins.bold(size: 28))
                        .foregroundStyle(.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    
                    Text("Glad to see you! 👋 Enter your details below and access your account.")
                        .font(.Poppins.regular(size: 14))
                        .foregroundStyle(.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 24)
                    
                    FloatingField(text: $viewModel.email,
                                  placeHolder: "Email address",
                                  leftIcon: .icFieldEmail,
                                  errorMessage: viewModel.errorMessageEmail)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }
                    
                    FloatingField(text: $viewModel.password,
                                  placeHolder: "Password",
                                  secureField: true,
                                  leftIcon: .icFieldPassword,
                                  errorMessage: viewModel.errorMessagePassword)
                        .padding(.top, 12)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .password)
                    
                    RedButtonView(text: "Log in") {
                        viewModel.login()
                    }.padding(.top, 12)
                }.padding(.top, 24)
                    .padding(.horizontal, 16)
            }
            
        }.background(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .safeAreaInset(edge: .bottom, content: {
                BlackButtonView(text: "Create an Account") {
                    navigation.push(RegisterScreenView().asDestination(), animated: true)
                }.padding(.bottom, 16)
                    .padding(.horizontal, 16)
            })
            .onChange(of: viewModel.email) { newValue in
                viewModel.errorMessageEmail = nil
            }
            .onChange(of: viewModel.password) { newValue in
                viewModel.errorMessagePassword = nil
            }
            .onReceive(viewModel.loginCompletion) { loginCompletion in
            switch loginCompletion {
            case .failure(_):
                let modal = ModalChooseOptionView(title: "Error",
                                      description: "An error has occured. Please try again.",
                                                  topButtonText: "Try again") {
                    navigation.dismissModal(animated: true, completion: nil)
                }
                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
            case .login:
                navigation.replaceNavigationStack([MainScreenView().asDestination()], animated: true)
            }
        }
    }
}
