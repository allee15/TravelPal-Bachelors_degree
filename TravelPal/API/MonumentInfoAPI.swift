//
//  MonumentInfoAPI.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import Foundation
import Combine
import SwiftyJSON

let PORT: String = "5001"
let IP: String = "192.168.100.36"

class MonumentInfoAPI {
    func getInfo(monumentName: String) -> Future<Monument, Error> {
        Future { promise in
            
            var urlComponents = URLComponents(string: "http://\(IP):\(PORT)/information")
            urlComponents?.queryItems = [
                URLQueryItem(name: "query", value: monumentName)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            urlRequest.httpMethod = "GET"
            
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
    
    func sendImageUrlToSerpAPI(imageUrl: String) -> Future<String, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "https://serpapi.com/search.json")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "engine", value: "google_lens"),
                URLQueryItem(name: "url", value: imageUrl),
                URLQueryItem(name: "api_key", value: "9ef96721bebb135b08efb096c51f7e8bfaee8a9511be7df5bb3c53a28f2ec6da")
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else { return }
                guard let data else { return }
                
                do {
                    
                    let json = try JSON(data: data)
                    var monument: String = ""
                    
                    if let visualMatches = json["visual_matches"].array {
                        if let matchAtPosition1 = visualMatches.first(where: { $0["position"].intValue == 1 }) {
                            let title = matchAtPosition1["title"].stringValue
                            let words = title.split(separator: " ")
                            let firstThreeWords = words.prefix(3)
                            monument = firstThreeWords.joined(separator: " ") 
                        }
                    }
                    
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
