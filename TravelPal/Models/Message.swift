//
//  Message.swift
//  TravelPal
//
//  Created by Aldea Alexia on 22.08.2023.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: String = UUID().uuidString
    var date: Date
    var message: String
    var email: String
    var name: String
    var imageUrl: String?
}
