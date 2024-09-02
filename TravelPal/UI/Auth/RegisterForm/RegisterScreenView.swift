//
//  LogInView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 03.08.2023.
//

import SwiftUI
import Kingfisher

struct RegisterScreenView: View {
    @StateObject var viewModel = RegisterViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    @FocusState var focusedField: RegisterField?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            NavBarView()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Let’s create your account")
                        .font(.Poppins.bold(size: 28))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    
                    Text("Please enter your details below")
                        .font(.Poppins.regular(size: 14))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 24)
                    
                    VStack(spacing: 12) {
                        FloatingField(text: $viewModel.name,
                                      placeHolder: "Name",
                                      leftIcon: .icFieldAccount,
                                      errorMessage: viewModel.errorMessageName)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .name)
                        
                        SelectGenderView(gender: $viewModel.selectedGender,
                                         gendersList: viewModel.gender,
                                         errorMessage: viewModel.errorMessageGender)
                        
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
                        .submitLabel(.done)
                        .focused($focusedField, equals: .password)
                        
                        HStack(alignment: .top) {
                            Toggle(isOn: $viewModel.showGreeting) {
                                Group {
                                    Text("I read and agree to ")
                                        .foregroundColor(.black)
                                    + Text("The Terms and Conditions")
                                        .foregroundColor(Color.accentMain)
                                    
                                }.font(.Poppins.regular(size: 14))
                                    .onTapGesture {
                                        let webview = WebViewScreen(
                                            title: "Terms and Conditions",
                                            url: URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=PiVV3ZACQYyqXIbXBFFhQMDNtBY90XBx")!
                                        ).asDestination()
                                        navigation.push(webview, animated: true)
                                    }
                            }.toggleStyle(CheckboxToggleStyle())
                            Spacer()
                        }
                        
                        if let error = viewModel.errorMessageToggle {
                            HStack {
                                Text(error)
                                    .font(.Poppins.regular(size: 12))
                                    .foregroundColor(Color.accentMain)
                                Spacer()
                            }
                            .padding(.top, 4)
                        }
                        
                        RedButtonView(text: "Create account") {
                            viewModel.allFieldAreCompleted()
                        }
                    }
                }.padding(.top, 24)
                    .padding(.horizontal, 16)
            }
        }.background(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.name) { newValue in
                viewModel.errorMessageName = nil
            }
            .onChange(of: viewModel.selectedGender) { newValue in
                viewModel.errorMessageGender = nil
            }
            .onChange(of: viewModel.email) { newValue in
                viewModel.errorMessageEmail = nil
            }
            .onChange(of: viewModel.password) { newValue in
                viewModel.errorMessagePassword = nil
            }
            .onChange(of: viewModel.showGreeting) { newValue in
                viewModel.errorMessageToggle = nil
            }
            .onReceive(viewModel.registerCompletion) { registerCompletion in
                switch registerCompletion {
                case .failure(_):
                    let modal = ModalChooseOptionView(title: "Error",
                                          description: "An error has occured. Please try again.",
                                                      topButtonText: "Try again") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                case .register:
                    navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
                }
            }
    }
}

fileprivate struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(configuration.isOn ? "Type=On" : "Type=Off")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundColor(Color.bgSecondary)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}
