//
//  FirestoreService.swift
//  TravelPal
//
//  Created by Aldea Alexia on 24.08.2023.
//

import Foundation
import FirebaseFirestore
import Firebase
import Combine
import FirebaseStorage

enum ViewModelEvent {
    case completed
}

class FirestoreService: BaseViewModel {
    @Published var user: User?
    var imageArray: [UIImage] = []
    var userCities = CurrentValueSubject<[City], Never>([])
    var messages = CurrentValueSubject<[Message], Never>([])
    var gender = CurrentValueSubject<String, Never>("")
    var username = CurrentValueSubject<String, Never>("")
    private var db = Firestore.firestore()
    static let shared = FirestoreService()
    private var userService = UserService.shared
    
    private var userCitiesListener: ListenerRegistration?
    
    override init() {
        super.init()
        userService.user
            .sink { _ in
                
            } receiveValue: { user in
                self.userCities.value = []
                self.userCitiesListener?.remove()
                self.user = user
                
                if let user {
                    self.fetchChatsFromUser(userID: user.uid)
                }
                
            } .store(in: &bag)
    }
    
    func fetchChatsFromUser(userID: String) {
        userCitiesListener = db.collection("Users").document(userID).addSnapshotListener { documentSnapshot, error in
            self.userCities.value = []
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = documentSnapshot, document.exists, let data = document.data() {
                if let chats = data["chats"] as? [String] {
                    chats.forEach { cityName in
                        self.countUsersFromChat(cityID: cityName) { nrOfPersons in
                            self.userCities.value.append(City(name: cityName, numberOfPerson: nrOfPersons))
                        }
                    }
                } else {
                    print("'chats' field is not an array of strings or does not exist")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func countUsersFromChat(cityID: String, completion: @escaping ((Int) -> Void)) {
        self.db.collection("Chat").document(cityID).collection("Users").getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                completion(0)
                return
            }
            
            let count = documents.count
            completion(count)
        }
    }
    
    func fetchChatDetails(cityID: String) {
        db.collection("Chat").document(cityID).collection("Message").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            print(documents)
            self.messages.value = documents.map { queryDocumentSnapshot -> Message in
                let data = queryDocumentSnapshot.data()
                
                let date = (data["date"] as! Timestamp).dateValue()
                let message = data["message"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                return Message(id: queryDocumentSnapshot.documentID,
                               date: date,
                               message: message,
                               email: email,
                               name: name)
            }.sorted(by: {$0.date < $1.date})
        }
    }
    
    func addUserDetails(name: String, gender: String) {
        let documentRef = db.collection("Users").document(user!.uid)
        
        documentRef.setData(["name": name, "gender": gender]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func fetchGender(userId: String) {
        db.collection("Users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists, let data = document.data() {
                if let gender = data["gender"] as? String {
                    self.gender.value = gender
                } else {
                    print("'gender' field is not an array of strings or does not exist")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func fetchName(userId: String) {
        db.collection("Users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists, let data = document.data() {
                if let name = data["name"] as? String {
                    self.username.value = name
                } else {
                    print("'name' field is not an array of strings or does not exist")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func createUser() {
        let documentRef = db.collection("Users").document(user!.uid)
        
        documentRef.setData([
            "chats": [String]()
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateUser(city: String) {
        let db = Firestore.firestore()
        let documentRef = db.collection("Users").document(self.user!.uid)
        
        documentRef.updateData([
            "chats": FieldValue.arrayUnion([city])
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func addUser(cityID: String) {
        db.collection("Chat").document(cityID).collection("Users").document(user!.uid).setData([:]) { error in
            if let error = error {
                print("Error adding user ID: \(error)")
            } else {
                print("User ID added successfully")
            }
        }
    }
    
    func countUsersFromChat(cityID: String) -> Future<Int, Error> {
        Future { promise in
            self.db.collection("Chat").document(cityID).collection("Users").getDocuments { querySnapshot, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    promise(.success(0))
                    return
                }
                
                let count = documents.count
                promise(.success(count))
            }
        }
    }
    
    func createChat(countryName: String) {
        db.collection("Chat").document(countryName).setData([:]) { error in
            if let error = error {
                print("Error adding chat: \(error)")
            } else {
                print("Chat added successfully")
            }
        }
    }
    
    func removeUserFromChat(cityID: String) {
        db.collection("Chat").document(cityID).collection("Users").document(user!.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                let userRef = self.db.collection("Users").document(self.user!.uid)
                userRef.updateData([
                    "chats": FieldValue.arrayRemove([cityID])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated!")
                        self.fetchChatsFromUser(userID: self.user!.uid)
                    }
                }
            }
        }
    }
    
    func updateUserName(name: String) {
        let documentRef = db.collection("Users").document(self.user!.uid)
        
        documentRef.updateData([
            "name": name
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func updateUserGender(gender: String) {
        let documentRef = db.collection("Users").document(self.user!.uid)
        
        documentRef.updateData([
            "gender": gender
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
}
