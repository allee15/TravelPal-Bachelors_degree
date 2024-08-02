// AccomodationRecomandationsViewModel.swift
// TravelPal
//
// Created by Aldea Alexia on 07.08.2023.
//

import Foundation
import UIKit
import FirebaseFirestore
import Combine
import PDFKit
import SwiftUI

class AccomodationViewModel: BaseViewModel {
    @Published var route: Route
    @Published var weekDay: String
    @Published var countUsers: Int
    @Published var countryDep: Country
    @Published var countryArr: Country
    @Published var image: Image?
    @Published var hotels: [String] = ["img_hotel1",
                                       "img_hotel2",
                                       "img_hotel3",
                                       "img_hotel4",
                                       "img_hotel5",
                                       "img_hotel6",
                                       "img_hotel7",
                                       "img_hotel8",
                                       "img_hotel9",
                                       "img_hotel0"]
    
    var firestoreService = FirestoreService.shared
    var address: String
    
    init(route: Route, weekDay: String, countryDep: Country, countryArr: Country, countUsers: Int, image: Image?) {
        self.route = route
        self.address = route.arrName
        self.weekDay = weekDay
        self.countryDep = countryDep
        self.countryArr = countryArr
        self.countUsers = countUsers
        self.image = image
        super.init()
    }
    
    func updateUser() {
        firestoreService.updateUser(city: countryArr.countryName)
    }
    
    func addUser() {
        firestoreService.addUser(cityID: countryArr.countryName)
    }
    
    func openAirBnb() {
        if let encodedDestination = route.arrName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "https://www.airbnb.com/s/\(encodedDestination)/homes?tab_id=home_tab&refinement_paths%5B%5D=%2Fhomes&flexible_trip_lengths%5B%5D=one_week&monthly_length=3&price_filter_input_type=0&price_filter_num_nights=5&channel=EXPLORE&date_picker_type=calendar&checkin=2024-07-03&checkout=2024-07-04&adults=1&source=structured_search_input_header&search_type=filter_change") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openMap() {
        if let encodedAddress = self.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "https://www.google.com/maps/place/\(encodedAddress)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func addChat() {
        firestoreService.createChat(countryName: countryArr.countryName)
    }
}

