//
//  MonumentInfoService.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import Foundation
import Combine

class MonumentInfoService {
    static let shared = MonumentInfoService()
    private let monumentInfoAPI = MonumentInfoAPI()
    private init() { }
    
    func getInfo(monumentName: String) -> Future<Monument, Error> {
        monumentInfoAPI.getInfo(monumentName: monumentName)
    }
    
    func sendImageUrlToSerpAPI(imageUrl: String) -> Future<String, Error> {
        monumentInfoAPI.sendImageUrlToSerpAPI(imageUrl: imageUrl)
    }
}
