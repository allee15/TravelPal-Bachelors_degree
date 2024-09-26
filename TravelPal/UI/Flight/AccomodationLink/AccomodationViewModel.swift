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
        if let url = URL(string: "https://www.airbnb.com/s/\(route.arrName.replaceSpacesWithUnderscores())/homes") {
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

