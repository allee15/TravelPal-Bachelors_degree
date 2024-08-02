//
//  ChatsViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 12.08.2023.
//

import Foundation
import FirebaseFirestore

class ChatViewModel: BaseViewModel {
    @Published var messages: [Message] = []
    @Published var email = ""
    var userService = UserService.shared
    private var db = Firestore.firestore()
    
    override init() {
        super.init()
        userService.user
            .sink { _ in
            
            } receiveValue: { user in
                self.email = user?.email ?? ""
            } .store(in: &bag)
        fetchData()
    }
    
    func fetchData() {
        db.collection("Chat").document("Brasov").collection("Message").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            print(documents)
            self.messages = documents.map { queryDocumentSnapshot -> Message in
                let data = queryDocumentSnapshot.data()
                
                guard let date = data["date"] as? Date,
                      let message = data["message"] as? String,
                      let userName = data["userName"] as? String else {
                    print("Error: Document data could not be casted to expected types")
                    return Message(date: Date.now, message: "", userName: "")
                }
                
                return Message(id: queryDocumentSnapshot.documentID, date: date, message: message, userName: userName)
            }
        }
    }
}

