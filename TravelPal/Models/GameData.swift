//
//  GameData.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import Foundation
import SwiftUI

struct GameData {
    var id = UUID()
    let title: String
    let description: String
    let question: String
    let pointsNumber: Int
    let image: ImageResource
}
