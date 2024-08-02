//
//  DepartureOptionsViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 07.08.2023.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class DepartureOptionsViewModel: BaseViewModel {
    @Published var route: Route
    @Published var user: User?
    @Published var weekDay: String
    @Published var depAirport: Airport
    @Published var arrAirport: Airport
    @Published var countryDep: Country
    @Published var countryArr: Country
    @Published var countUsers: Int
    @Published var selectedDate: Date
    @Published var tabSelected: TabSelected = .flight
    
    var userService = UserService.shared
    
    init(route: Route, weekDay: String, address: String, depAirport: Airport, arrAirport: Airport, countryDep: Country, countryArr: Country, countUsers: Int, selectedDate: Date) {
        self.route = route
        self.weekDay = weekDay
        self.depAirport = depAirport
        self.arrAirport = arrAirport
        self.countryDep = countryDep
        self.countryArr = countryArr
        self.countUsers = countUsers
        self.selectedDate = selectedDate
        
        super.init()
        
        userService.user
            .sink { _ in
                
            } receiveValue: { user in
                self.user = user
            } .store(in: &bag)
        
    }
}

