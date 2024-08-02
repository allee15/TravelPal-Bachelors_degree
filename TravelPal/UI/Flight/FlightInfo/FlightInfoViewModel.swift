//
//  FlightInfoViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 04.08.2023.
//

import Foundation
import CoreLocation
import Combine

enum AirportsState {
    case loading
    case failure(Error)
    case value([Airport])
}

enum RoutesState {
    case loading
    case failure(Error)
    case value([Route])
}

enum CountriesState {
    case loading
    case failure(Error)
    case value([Country])
}

class FlightInfoViewModel: BaseViewModel {
    @Published var airportsState = AirportsState.loading
    @Published var routesState = RoutesState.loading
    @Published var countriesState = CountriesState.loading
    @Published var departureAirport: Airport? = nil
    @Published var departureOption: Bool = false
    @Published var departureTextField = "" {
        didSet {
            if oldValue != departureTextField {
                departureOption = departureTextField.count > 0
            }
        }
    }
    @Published var arrivalAirport: Airport? = nil
    @Published var arrivalOption: Bool = false
    @Published var arrivalTextField = "" {
        didSet {
            if oldValue != arrivalTextField {
                arrivalOption = arrivalTextField.count > 0
            }
        }
    }
    @Published var filteredAirports: [Airport] = []
    @Published var selectionWasMade: Bool = false
    @Published var selectedDate = Date.now
    
    var weekDay: String {
        let customDateFormatter = DateFormatter()
        let calendar = Calendar.current
        let previousDay = calendar.date(byAdding: .day, value: -1, to: selectedDate)!
        return customDateFormatter.weekdaySymbols[calendar.component(.weekday, from: previousDay)]
    }
    let airportsService = AirportsService.shared
    let routesService = RoutesService.shared
    let countriesService = CountriesService.shared
    
    
    override init() {
        super.init()
        loadAirports()
        loadRoutes()
        loadCountries()
    }
    
    func loadAirports() {
        airportsState = .loading
        airportsService.getAirports()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.airportsState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] airports in
                guard let self else {return}
                self.airportsState = .value(airports)
            } .store(in: &bag)
    }
    
    func loadRoutes() {
        routesState = .loading
        routesService.getRoutes(depAirport: self.departureAirport, arrAirport: self.arrivalAirport)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.routesState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] routes in
                guard let self else {return}
                self.routesState = .value(routes)
            } .store(in: &bag)
    }
    
    func getAirport(icaoCode: String, iataCode: String) -> Airport? {
        switch airportsState {
        case .loading:
            return nil
        case .failure(_):
            return nil
        case .value(let airports):
            return airports.first(where: { $0.iataCode == iataCode && $0.icaoCode == icaoCode })
        }
    }
    
    func getCountryByAirport(airport: Airport) -> Country? {
        switch countriesState {
        case .loading:
            return nil
        case .failure(_):
            return nil
        case .value(let countries):
            return countries.first(where: { $0.countryCode == airport.countryCode })
        }
    }
    
    func loadCountries() {
        countriesState = .loading
        countriesService.getCountries()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.countriesState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] countries in
                guard let self else {return}
                self.countriesState = .value(countries)
            } .store(in: &bag)
    }
    
    func filterAirports(airports: [Airport]) {
        guard !departureTextField.isEmpty && !arrivalTextField.isEmpty else {
            return
        }

        self.filteredAirports = airports.filter { airport in
            let departureMatch = airport.name.localizedCaseInsensitiveContains(departureTextField)
            if departureMatch {
                self.filteredAirports.append(airport)
            }
            let arrivalMatch = airport.name.localizedCaseInsensitiveContains(arrivalTextField)
            if arrivalMatch {
                self.filteredAirports.append(airport)
            }
            return departureMatch || arrivalMatch
        }
    }
}
