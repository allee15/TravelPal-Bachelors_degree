//
//  Chat.swift
//  TravelPal
//
//  Created by Aldea Alexia on 22.08.2023.
//

import Foundation

struct Chat: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var city: String
}
