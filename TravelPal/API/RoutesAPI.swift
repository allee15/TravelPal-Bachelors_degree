//
//  RoutesAPI.swift
//  TravelPal
//
//  Created by Aldea Alexia on 28.08.2023.
//

import Foundation
import Combine
import SwiftyJSON

class RoutesAPI {
    func getRoutes(depAirport: Airport?, arrAirport: Airport?) -> Future<[Route], Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "https://airlabs.co/api/v9/routes")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "dep_iata", value: depAirport?.iataCode ?? "OTP")
            ]
            
            if let arrIataCode = arrAirport?.iataCode {
                urlComponents?.queryItems?.append(URLQueryItem(name: "arr_iata", value: arrIataCode))
            }
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [Route]()
                        let json = try JSON(data: data!)
                        let routes = json["response"]
                        for (_, item) in routes {
                            let route = Route(airlineIata: item["airline_iata"].stringValue,
                                               airlineIcao: item["airline_icao"].stringValue,
                                               flightNumber: item["flight_number"].stringValue,
                                               flightIata: item["flight_iata"].stringValue,
                                               flightIcao: item["flight_icao"].stringValue,
                                               depIata: item["dep_iata"].stringValue,
                                               depIcao: item["dep_icao"].stringValue,
                                               depName: depAirport?.name ?? "",
                                               depTimeUtc: item["dep_time_utc"].stringValue,
                                               arrIata: item["arr_iata"].stringValue,
                                               arrIcao: item["arr_icao"].stringValue,
                                               arrName: arrAirport?.name ?? "",
                                               arrTimeUtc: item["arr_time_utc"].stringValue,
                                               duration: item["duration"].intValue,
                                               days: item["days"].arrayValue.map { $0.stringValue })
                            arrayToReturn.append(route)
                        }
                        promise(.success(arrayToReturn))
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
}
