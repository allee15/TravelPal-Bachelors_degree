//
//  RoutesService.swift
//  TravelPal
//
//  Created by Aldea Alexia on 28.08.2023.
//

import Foundation
import Combine

class RoutesService {
    static let shared = RoutesService()
    private let routesApi = RoutesAPI()
    private init() { }
    
    func getRoutes(depAirport: Airport?, arrAirport: Airport?) -> Future<[Route], Error> {
//                routesApi.getRoutes(depAirport: depAirport, arrAirport: arrAirport)
        Future { promise in
            let routes: [Route] = [Route(airlineIata: "",
                                           airlineIcao: "GEC",
                                           flightNumber: "8200",
                                           flightIata: "",
                                           flightIcao: "GEC8200",
                                           depIata: "ORD",
                                           depIcao: "KORD",
                                           depName: depAirport?.name ?? "Otopeni",
                                           depTimeUtc: "05:05",
                                           arrIata: "DFW",
                                           arrIcao: "KDFW",
                                           arrName: arrAirport?.name ?? "Bucuresti",
                                           arrTimeUtc: "07:33",
                                           duration: 148,
                                           days: ["fri"]),
                                    Route(airlineIata: "",
                                           airlineIcao: "GEC",
                                           flightNumber: "8200",
                                           flightIata: "",
                                           flightIcao: "GEC8200",
                                           depIata: "ORD",
                                           depIcao: "KORD",
                                           depName: depAirport?.name ?? "Otopeni",
                                           depTimeUtc: "23:25",
                                           arrIata: "DFW",
                                           arrIcao: "KDFW",
                                           arrName: arrAirport?.name ?? "Bucuresti",
                                           arrTimeUtc: "01:56",
                                           duration: 151,
                                           days: ["thu"])]

            promise(.success(routes))
        }
    }
}
