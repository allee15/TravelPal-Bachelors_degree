//
//  LogInFormViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 03.08.2023.
//

import Foundation
import Combine
import FirebaseAuth

enum LoginCompletion {
    case login
    case failure(Error)
}

enum Field {
    case email
    case password
}

class LogInViewModel: BaseViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessageEmail: String?
    @Published var errorMessagePassword: String?
    
    let loginCompletion = PassthroughSubject<LoginCompletion, Never>()
    var userService = UserService.shared
    
    func login() {
        if email.isValidEmail() {
            userService.login(email: email, password: password)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .failure(let error):
                        self.loginCompletion.send(.failure(error))
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] user in
                    guard let self else { return }
                    self.loginCompletion.send(.login)
                }
                .store(in: &bag)
        } else {
            if password.isEmpty {
                self.errorMessagePassword = "Please enter a valid password."
            }
            self.errorMessageEmail = "Please enter a valid email address."
        }
    }
}
