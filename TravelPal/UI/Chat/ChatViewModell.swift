//
//  ChatsViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 12.08.2023.
//

import Foundation
import FirebaseFirestore
import Firebase

class ChatViewModel: BaseViewModel {
    @Published var user: User?
    @Published var userCities: [City] = []
    @Published var countUsers: Int = -1
    
    var userService = UserService.shared
    var firestoreService = FirestoreService.shared
    
    override init() {
        super.init()
        userService.user
            .sink { _ in
                
            } receiveValue: { user in
                self.user = user
            } .store(in: &bag)
       
        firestoreService.userCities
            .sink { _ in
                
            } receiveValue: { cities in
                self.userCities = cities
            } .store(in: &bag)
        
    }
}

