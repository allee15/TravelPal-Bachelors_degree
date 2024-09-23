//
//  AirbnbService.swift
//  TravelPal
//
//  Created by Alexia Aldea on 23.09.2024.
//

import Foundation
import Combine

class AirbnbService {
    static let shared = AirbnbService()
    private let airbnbAPI = AirbnbAPI()
    private init() { }
    
    func getProperties(location: String) -> Future<[Property], Error> {
        airbnbAPI.getProperties(location: location)
    }
}
