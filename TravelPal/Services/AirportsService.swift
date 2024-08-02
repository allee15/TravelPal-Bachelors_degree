//
//  AirportsService.swift
//  TravelPal
//
//  Created by Aldea Alexia on 28.08.2023.
//

import Foundation
import Combine

class AirportsService {
    static let shared = AirportsService()
    private let airportsApi = AirportsAPI()
    private init() { }
    
    func getAirports() -> Future<[Airport], Error> {
//                airportsApi.getAirports()
        Future { promise in
            let airports: [Airport] = [ Airport(name: "Chicago O'Hare International Airport",
                                                  iataCode: "ORD",
                                                  icaoCode: "KORD",
                                                  latitude: 41.978367,
                                                  longitude: -87.904712,
                                                  countryCode: "US"),
                                         Airport(name: "Hartsfield-Jackson Atlanta International Airport",
                                                  iataCode: "ATL",
                                                  icaoCode: "KATL",
                                                  latitude: 33.639253,
                                                  longitude: -84.431594,
                                                  countryCode: "US"),
                                         Airport(name: "Dallas/Fort Worth International Airport",
                                                  iataCode: "DFW",
                                                  icaoCode: "KDFW",
                                                  latitude: 32.896738,
                                                  longitude: -97.03711,
                                                  countryCode: "US"),
                                         Airport(name: "Los Angeles International Airport",
                                                  iataCode: "LAX",
                                                  icaoCode: "KLAX",
                                                  latitude: 33.942803,
                                                  longitude: -118.408415,
                                                  countryCode: "US"),
                                         Airport(name: "Soekarno-Hatta International Airport",
                                                  iataCode: "CGK",
                                                  icaoCode: "WIII",
                                                  latitude:  -6.127261,
                                                  longitude: 106.655808,
                                                  countryCode: "ID")]
            promise(.success(airports))
        }
    }
}
