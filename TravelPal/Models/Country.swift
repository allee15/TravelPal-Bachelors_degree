//
//  Country.swift
//  TravelPal
//
//  Created by Aldea Alexia on 30.08.2023.
//

import Foundation

struct Country: Decodable, Identifiable {
    var id: UUID = UUID()
    let countryCode: String
    let countryName: String
}
