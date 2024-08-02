//
//  FlightDetailsCardViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 04.08.2023.
//

import Foundation
import CoreLocation

class RoutesViewModel: BaseViewModel {
    @Published var route: Route
    @Published var weekDay: String
    @Published var depAirport: Airport?
    @Published var arrAirport: Airport?
    @Published var countryDep: Country
    @Published var countryArr: Country
    @Published var countUsers: Int = -1
    @Published var selectedDate: Date
    
    var firestoreService = FirestoreService.shared
    init(route: Route, weekDay: String, depAirport: Airport?, arrAirport: Airport?, countryDep: Country, countryArr: Country, selectedDate: Date) {
        self.route = route
        self.weekDay = weekDay
        self.depAirport = depAirport
        self.arrAirport = arrAirport
        self.countryDep = countryDep
        self.countryArr = countryArr
        self.selectedDate = selectedDate
        super.init()
        countUsersFromChat(countryName: countryArr.countryName)
    }
    
    func countUsersFromChat(countryName: String) {
        self.firestoreService.countUsersFromChat(cityID: countryName)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error counting users: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] count in
                self?.countUsers = count
            })
            .store(in: &self.bag)
    }
}

