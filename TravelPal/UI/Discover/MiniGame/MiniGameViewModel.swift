//
//  MiniFileViewModel.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import Foundation

class MiniGameViewModel: BaseViewModel {
    @Published var points: Int = 0
    
    func addPoints() {
        self.points += 15
    }
    
    func deletePoints() {
        self.points -= 15
    }
}
