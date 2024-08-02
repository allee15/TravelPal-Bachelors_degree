//
//  CountriesService.swift
//  TravelPal
//
//  Created by Aldea Alexia on 30.08.2023.
//

import Foundation
import Combine

class CountriesService {
    static let shared = CountriesService()
    private let countriesApi = CountriesAPI()
    private init() { }
    
    func getCountries() -> Future<[Country], Error> {
//        countriesApi.getCountries()
        
        Future { promise in
            let countries: [Country] = [ Country(countryCode: "US", countryName: "United States"),
                                         Country(countryCode: "ID", countryName: "Indonesia")]
            promise(.success(countries))
        }
    }
}
