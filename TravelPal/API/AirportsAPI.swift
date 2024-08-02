//
//  AirportsAPI.swift
//  TravelPal
//
//  Created by Aldea Alexia on 28.08.2023.
//

import Foundation
import Combine
import SwiftyJSON

let apiKey: String = "b21a05bb-49a0-4823-84fe-c4a51ca08420"

class AirportsAPI {
    func getAirports() -> Future<[Airport], Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "https://airlabs.co/api/v9/airports")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [Airport]()
                        let json = try JSON(data: data!)
                        let airports = json["response"]
                        for (_, item) in airports {
                            let airport = Airport(name: item["name"].stringValue,
                                                   iataCode: item["iata_code"].stringValue,
                                                   icaoCode: item["icao_code"].stringValue,
                                                   latitude: item["lat"].doubleValue,
                                                   longitude: item["lng"].doubleValue,
                                                   countryCode: item["country_code"].stringValue)
                            arrayToReturn.append(airport)
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
