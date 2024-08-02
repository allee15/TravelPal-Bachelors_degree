//
//  CountriesAPI.swift
//  TravelPal
//
//  Created by Aldea Alexia on 30.08.2023.
//

import Foundation
import Combine
import SwiftyJSON

class CountriesAPI {
    func getCountries() -> Future<[Country], Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "https://airlabs.co/api/v9/countries")
            
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
                        var arrayToReturn = [Country]()
                        let json = try JSON(data: data!)
                        let countries = json["response"]
                        for (_, item) in countries {
                            let country = Country(countryCode: item["code"].stringValue,
                                                  countryName: item["name"].stringValue)
                            arrayToReturn.append(country)
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
