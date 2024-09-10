//
//  MonumentInfoAPI.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import Foundation
import Combine
import SwiftyJSON

let PORT: String = "5000"

class MonumentInfoAPI {
    func getInfo(monumentName: String) -> Future<Monument, Error> {
        Future { promise in
            
            var urlComponents = URLComponents(string: "http://127.0.0.1:\(PORT)/information/\(monumentName)")
            urlComponents?.queryItems = [
            ]
            
            var urlRequest = URLRequest(url: urlComponents!.url!)
            urlRequest.httpMethod = "POST"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else { return }
                guard let data else { return }
                
                do {
                    
                    let json = try JSON(data: data)
                    let data = json["query"].stringValue
                    let monument = Monument(description: data)
                    
                    promise(.success(monument))
                    
                } catch(let error) {
                    print(error)
                    promise(.failure(error))
                }
                
            }
            
            dataTask.resume()
        }
    }
}
