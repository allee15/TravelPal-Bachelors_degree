//
//  Routes.swift
//  TravelPal
//
//  Created by Aldea Alexia on 28.08.2023.
//

import Foundation

struct Route: Decodable, Hashable, Identifiable {
    var id: UUID = UUID()
    let airlineIata: String
    let airlineIcao: String
    let flightNumber: String
    let flightIata: String
    let flightIcao: String
    let depIata: String
    let depIcao: String
    let depName: String
    let depTimeUtc: String
    let arrIata: String
    let arrIcao: String
    let arrName: String
    let arrTimeUtc: String
    let duration: Int
    let days: [String]
}
