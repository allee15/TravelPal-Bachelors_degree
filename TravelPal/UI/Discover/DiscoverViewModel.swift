//
//  DiscoverViewModel.swift
//  TravelPal
//
//  Created by Alexia Aldea on 02.09.2024.
//

import Combine
import UIKit
import Firebase

enum ImageSendingToAPICompletion {
    case loading
    case completed(String)
    case error
}

class DiscoverViewModel: BaseViewModel {
    private var userService = UserService.shared
    private var monumentInfoService = MonumentInfoService.shared
    private var firestoreService = FirestoreService.shared
    
    @Published var user: User?
    @Published var image: UIImage?
    
    let imageSendingToAPICompletion = PassthroughSubject<ImageSendingToAPICompletion, Never>()
    
    override init() {
        super.init()
        userService.user
            .sink { _ in
                
            } receiveValue: { user in
                self.user = user
            } .store(in: &bag)
    }
    
    func sendImage() {
        guard let image = image else {
            imageSendingToAPICompletion.send(.error)
            return
        }
        
        imageSendingToAPICompletion.send(.loading)
        
        firestoreService.uploadImageToFirebase(image: image)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.imageSendingToAPICompletion.send(.error)
                }
            }, receiveValue: { [weak self] value in
                guard let self else {return}
                self.sendImageToGoogleLensAPI(imageURL: value)
            }).store(in: &bag)
    }
    
    private func sendImageToGoogleLensAPI(imageURL: String) {
        monumentInfoService.sendImageUrlToSerpAPI(imageUrl: imageURL)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.imageSendingToAPICompletion.send(.error)
                }
            } receiveValue: { [weak self] monumentName in
                guard let self else {return}
                self.imageSendingToAPICompletion.send(.completed(monumentName))
            }.store(in: &bag)
    }
}
