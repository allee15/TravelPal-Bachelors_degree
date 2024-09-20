//
//  ConversationViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 23.08.2023.
//

import Foundation
import FirebaseFirestore
import Firebase
import Combine

class ConversationViewModel: BaseViewModel {
    @Published var city: String
    @Published var user: User?
    @Published var message = ""
    @Published var messages: [Message] = []
    @Published var username: String = ""
    @Published var image: UIImage?
    
    var userService = UserService.shared
    var firestoreService = FirestoreService.shared
    
    init(city: String) {
        self.city = city
        super.init()
        
        userService.user
            .sink { _ in
            
            } receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.user = user
                if let user {
                    firestoreService.fetchName(userId: user.uid)
                }
            } .store(in: &bag)
        
        firestoreService.username
            .sink { _ in
                
            } receiveValue: { username in
                self.username = username
            } .store(in: &bag)
        
        firestoreService.fetchChatDetails(cityID: city)
        firestoreService.messages
            .sink { _ in
                
            } receiveValue: { messages in
                self.messages = messages
            } .store(in: &bag)
    }
    
    func sendMessage() {
        let db = Firestore.firestore()
        var newDocument: DocumentReference?
        
        newDocument = db.collection("Chat").document(self.city).collection("Message").addDocument(data: [
            "email": self.user?.email as Any,
            "message": self.message,
            "date": Timestamp(date: Date()),
            "name": self.username
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else  if let document = newDocument {
                print("Document added with ID: \(document.documentID)")
                self.message = ""
            }
        }
    }
    
    func removeUserFromChat() {
           firestoreService.removeUserFromChat(cityID: city)
       }
}
