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

enum PropertiesState {
    case loading
    case failure(Error)
    case value([Property])
}

class AccomodationViewModel: BaseViewModel {
    private var firestoreService = FirestoreService.shared
    private var airbnbService = AirbnbService.shared
    
    @Published var route: Route
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
    @Published var propertiesState = PropertiesState.loading
    
    init(route: Route, countryArr: Country, image: Image?) {
        self.route = route
        self.countryArr = countryArr
        self.image = image
        super.init()
        self.getAirbnbProperties()
    }
    
    private func getAirbnbProperties() {
        self.propertiesState = .loading
        let locationName = self.route.arrName.replaceSpacesWithUnderscores()
        airbnbService.getProperties(location: locationName)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.propertiesState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] properties in
                guard let self else {return}
                self.propertiesState = .value(properties)
            }.store(in: &bag)
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
        if let encodedAddress = self.route.arrName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "https://www.google.com/maps/place/\(encodedAddress)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func addChat() {
        firestoreService.createChat(countryName: countryArr.countryName)
    }
}

