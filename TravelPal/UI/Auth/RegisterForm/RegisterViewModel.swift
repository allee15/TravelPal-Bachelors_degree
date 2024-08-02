//
//  RegisterViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 16.08.2023.
//

import Foundation
import UIKit
import Combine
import Firebase
import FirebaseFirestore

enum RegisterCompletion {
    case register
    case failure(Error)
}

enum RegisterField {
    case name
    case email
    case password
}

class RegisterViewModel: BaseViewModel {
    @Published var showGreeting: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var gender: [String] = ["Mr.", "Mrs.", "Other"]
    @Published var isPickerShown = false
    @Published var selectedGender: String = ""
    @Published var name: String = ""
    @Published var errorMessageName: String?
    @Published var errorMessageGender: String?
    @Published var errorMessageEmail: String?
    @Published var errorMessagePassword: String?
    @Published var errorMessageToggle: String?
    
    let registerCompletion = PassthroughSubject<RegisterCompletion, Never>()
    var userService = UserService.shared
    var firestoreService = FirestoreService.shared
    
    func allFieldAreCompleted() {
        if name.isEmpty {
            self.errorMessageName = "This field is required."
        }
        
        if selectedGender.isEmpty {
            self.errorMessageGender = "This field is required."
        }
        
        if !email.isValidEmail() {
            self.errorMessageEmail = "Please enter a valid email address."
        }
        
        if password.isEmpty {
            self.errorMessagePassword = "This field is required."
        } else if password.count < 6 {
            self.errorMessagePassword = "Password must contain at least 6 characters."
        }
        
        if !showGreeting {
            self.errorMessageToggle = "Please accept terms."
        }
        
        if showGreeting && errorMessageName == nil && errorMessageGender == nil && errorMessageEmail == nil, errorMessagePassword == nil {
            self.register()
        }
    }
    
    private func register() {
        userService.register(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.registerCompletion.send(.failure(error))
                case .finished:
                    self.firestoreService.createUser()
                    self.firestoreService.addUserDetails(name: self.name, gender: self.selectedGender)
                }
            } receiveValue: { [weak self] user in
                guard let self else { return }
                self.registerCompletion.send(.register)
            }
            .store(in: &bag)
    }
    
    func redirectToTerms() {
        if let url = URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=PiVV3ZACQYyqXIbXBFFhQMDNtBY90XBx"){
            UIApplication.shared.open(url)
        }
    }
}
