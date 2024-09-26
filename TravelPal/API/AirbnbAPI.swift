//
//  AirbnbAPI.swift
//  TravelPal
//
//  Created by Alexia Aldea on 23.09.2024.
//

import Foundation
import Combine
import SwiftyJSON

class AirbnbAPI {
    func getProperties(location: String) -> Future<[Property], Error> {
        Future { promise in
            
            var urlComponents = URLComponents(string: "http://\(IP):\(PORT)/properties")
            urlComponents?.queryItems = [
                URLQueryItem(name: "location", value: location)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else { return }
                guard let data else { return }
                
                do {
                    var arrayToReturn = [Property]()
                    let json = try JSON(data: data)
                    let properties = json["properties"]
                    for (_, item) in properties {
                        let property = Property(title: item["title"].stringValue,
                                                image: item["image"].stringValue,
                                                price: item["price"].stringValue)
                        arrayToReturn.append(property)
                    }
                    promise(.success(arrayToReturn))
                    
                } catch {
                    promise(.failure(error))
                }
            }
            
            dataTask.resume()
        }
    }
}
