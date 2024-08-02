//
//  FlightWithCity.swift
//  TravelPal
//
//  Created by Aldea Alexia on 21.08.2023.
//

import Foundation

struct Airport: Identifiable, Decodable {
    var id: UUID = UUID()
    let name: String
    let iataCode: String
    let icaoCode: String
    let latitude: Double
    let longitude: Double
    let countryCode: String
}
