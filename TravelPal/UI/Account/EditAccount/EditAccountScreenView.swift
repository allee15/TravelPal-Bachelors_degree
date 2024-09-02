//
//  EditAccountScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 06.01.2024.
//

import SwiftUI

struct EditAccountScreenView: View {
    @StateObject private var viewModel = EditAccountViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    @State var isPickerShown = false
    @State var changesMade: Bool = false
    @State var newName: String = ""
    @State var newGender: String = ""
    @State var newEmail: String = ""
    @State var newPassword: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                BackButton {
                    if changesMade == true {
                        let modal = ModalChooseOptionView(title: "Are you sure?",
                                                          description: "If you leave this page, your changes won't be saved.",
                                                          topButtonText: "Leave",
                                                          bottomButtonText: "Stay") {
                            navigation.dismissModal(animated: true, completion: nil)
                            navigation.pop(animated: true)
                        } onBottomButtonTapped: {
                            navigation.dismissModal(animated: true, completion: nil)
                        }

                        navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                    } else {
                        navigation.pop(animated: true)
                    }
                }
                
                Text("Edit account")
                    .font(.Poppins.semiBold(size: 24))
                    .foregroundColor(.black)
                
                Spacer()
            }.padding(.horizontal, 16)
                .padding(.vertical, 24)
            
            VStack(spacing: 12) {
                FloatingField(text: $viewModel.userEmail,
                              placeHolder: "Email address",
                              leftIcon: .icFieldEmail, 
                              isDisabled: true)
                
                FloatingField(text: $viewModel.username,
                              placeHolder: "Name",
                              leftIcon: .icFieldAccount)
                
                SelectGenderView(gender: $viewModel.currentGender,
                                 gendersList: viewModel.gender)
                
            }.padding(.horizontal, 16)
            
            Spacer(minLength: 80)
            
            BlackButtonView(text: "Save Changes", isDisabled: changesMade ? false : true) {
                if newName != "" {
                    viewModel.updateUserName(newName: newName)
                }
                
                if newGender != "" {
                    viewModel.updateUserGender(newGender: newGender)
                }
                
                navigation.pop(animated: true)
                ToastManager.instance.show(
                    Toast(
                        text: "Edit successful!",
                        textColor: Color.accentTertiary
                    ))
            }.padding(.horizontal, 16)
        }.background(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.username) { newValue in
                changesMade = true
                newName = newValue
            }
            .onChange(of: viewModel.currentGender) { newValue in
                changesMade = true
                newGender = newValue
            }
    }
}

