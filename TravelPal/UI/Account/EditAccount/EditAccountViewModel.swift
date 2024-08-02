//
//  EditAccountViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 06.01.2024.
//

import Foundation
import Firebase
import FirebaseAuth

class EditAccountViewModel: BaseViewModel {
    @Published var user: User?
    @Published var currentGender: String = ""
    @Published var username: String = ""
    @Published var gender: [String] = ["Mr.", "Mrs.", "Other"]
    @Published var userEmail: String = ""
    
    var userService = UserService.shared
    var firestoreService = FirestoreService.shared
    
    override init() {
        super.init()
        userService.user
            .sink { _ in
            
            } receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.user = user
                if let user {
                    self.userEmail = user.email ?? ""
                    firestoreService.fetchGender(userId: user.uid)
                }
            } .store(in: &bag)
        
        firestoreService.username
            .sink { _ in
                
            } receiveValue: { username in
                self.username = username
            } .store(in: &bag)
        
        firestoreService.gender
            .sink { _ in
                
            } receiveValue: { currentGender in
                self.currentGender = currentGender
            } .store(in: &bag)

    }
    
    func updateUserName(newName: String) {
        firestoreService.updateUserName(name: newName)
    }
    
    func updateUserGender(newGender: String) {
        firestoreService.updateUserGender(gender: newGender)
    }
}
