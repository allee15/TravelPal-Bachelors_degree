//
//  MiniFileViewModel.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import Foundation

class MiniGameViewModel: BaseViewModel {
    @Published var points: Int = 0
    @Published var pageIndex = 0
    
    let gamePages: [GameData] = [
//        GameData(title: <#T##String#>, description: <#T##String#>, question: <#T##String#>, pointsNumber: 5, image: <#T##ImageResource#>),
//        GameData(title: <#T##String#>, description: <#T##String#>, question: <#T##String#>, pointsNumber: 15, image: <#T##ImageResource#>),
//        GameData(title: <#T##String#>, description: <#T##String#>, question: <#T##String#>, pointsNumber: 30, image: <#T##ImageResource#>)
    ]
    
    func addPoints() {
        self.points += 15
    }
    
    func deletePoints() {
        self.points -= 15
    }
    
    func nextPage() {
        if pageIndex == gamePages.count - 1 {
//            self.emitEvent(.completed)
        } else if pageIndex < gamePages.count - 1 {
            pageIndex += 1
        }
    }
}
