//
//  MonumentInfoAPI.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import Foundation
import Combine
import SwiftyJSON

class MonumentInfoAPI {
    func getInfo(monumentName: String) -> Future<Monument, Error> {
        Future { promise in
            let urlComponents = URLComponents(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(monumentName)")
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let monument = Monument(title: json["title"].stringValue,
                                                description: json["description"].stringValue,
                                                extract: json["extract"].stringValue,
                                                link: json["content_urls"]["mobile"]["page"].stringValue)
                        
                        promise(.success(monument))
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
}
