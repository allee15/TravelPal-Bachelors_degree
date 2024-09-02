//
//  AccountViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 16.08.2023.
//

import Foundation
import Combine
import FirebaseAuth
import Firebase
import FirebaseStorage

enum LogOutCompletion {
    case logout
    case delete
    case failure(Error)
}

class AccountViewModel: BaseViewModel {
    @Published var user: User?
    @Published var gender: String = ""
    @Published var username: String = ""
    
    var userService = UserService.shared
    var firestoreService = FirestoreService.shared
    let eventSubject = PassthroughSubject<LogOutCompletion, Never>()
    
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "\(version) \(build)"
    }
    
    override init() {
        super.init()
        userService.user
            .sink { _ in
            
            } receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.user = user
                if let user {
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
                
            } receiveValue: { gender in
                self.gender = gender
            } .store(in: &bag)

    }
    
    func logOut() {
        userService.logOut()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.eventSubject.send(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                guard let self else { return }
                self.eventSubject.send(.logout)
            }
            .store(in: &bag)
    }
    
    func deleteAccount() {
        userService.deleteAccount()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.eventSubject.send(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                guard let self else { return }
                self.eventSubject.send(.delete)
            }
            .store(in: &bag)
    }
}
