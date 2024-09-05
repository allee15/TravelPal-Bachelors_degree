//
//  FlightInfoScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 04.08.2023.
//

import SwiftUI

struct FlightInfoScreenView: View {
    @StateObject var viewModel = FlightInfoViewModel()
    @FocusState private var isDepartureFieldFocused: Bool
    @FocusState private var isArrivalFieldFocused: Bool
    
    var body: some View {
        
        switch viewModel.airportsState {
        case .failure( _):
            VStack {
                Spacer()
                ErrorView()
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bgSecondary)
            
        case .loading:
            VStack {
                Spacer()
                LoaderView()
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bgSecondary)
            
        case .value(let airports):
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Image(.logoApp)
                        .resizable()
                        .frame(width: 142, height: 24)
                        .padding(.bottom, 12)
                    
                    var searchResultsDepartures: [Airport] {
                        if viewModel.departureTextField.isEmpty {
                            return airports
                        } else {
                            return airports.filter { $0.name.contains(viewModel.departureTextField) }
                        }
                    }
                    
                    SearchField(text: $viewModel.departureTextField,
                                placeHolder: "Select your departure",
                                leftIcon: .planeDeparting)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.contentSecondary)
                    
                    if viewModel.departureOption {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(searchResultsDepartures) { result in
                                    VStack {
                                        Rectangle()
                                            .frame(height: 1)
                                            .padding(.horizontal, 2)
                                            .foregroundColor(Color.contentSecondary)
                                            .padding(.bottom, 10)
                                        
                                        Text(result.name)
                                            .foregroundColor(.black)
                                            .font(.Poppins.regular(size: 16))
                                            .padding(.bottom, 10)
                                            .onTapGesture {
                                                viewModel.departureAirport = result
                                                viewModel.departureTextField = result.name
                                                viewModel.departureOption = false
                                            }
                                    }
                                }
                            }
                        }
                        .frame(height: searchResultsDepartures.count >= 3 ? 200 : 50 * CGFloat(searchResultsDepartures.count))
                        .background(
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(.linearGradient(colors: [.white, .white],
                                                      startPoint: .top,
                                                      endPoint: .bottomTrailing)))
                        .border(Color.black)
                    }
                    
                    var searchResultsArrivals: [Airport] {
                        if viewModel.arrivalTextField.isEmpty {
                            return airports
                        } else {
                            return airports.filter { $0.name.contains(viewModel.arrivalTextField) }
                        }
                    }
                    
                    SearchField(text: $viewModel.arrivalTextField,
                                placeHolder: "Select your destination",
                                leftIcon: .planeArriving)
                    
                    if viewModel.arrivalOption {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(searchResultsArrivals) { result in
                                    VStack {
                                        Rectangle()
                                            .frame(height: 1)
                                            .padding(.horizontal, 2)
                                            .foregroundColor(Color.contentSecondary)
                                            .padding(.bottom, 10)
                                        
                                        Text(result.name)
                                            .foregroundColor(.black)
                                            .font(.Poppins.regular(size: 16))
                                            .padding(.bottom, 10)
                                            .onTapGesture {
                                                viewModel.arrivalAirport = result
                                                viewModel.arrivalTextField = result.name
                                                viewModel.arrivalOption = false
                                            }
                                    }
                                }
                            }
                        }
                        .frame(height: searchResultsArrivals.count >= 3 ? 200 : 50 * CGFloat(searchResultsArrivals.count))
                        .background(
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(.linearGradient(colors: [.white, .white],
                                                      startPoint: .top,
                                                      endPoint: .bottomTrailing)))
                        .border(Color.black)
                    }
                    
                    HStack(spacing: 0) {
                        Image(.icCalendar)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                            .foregroundColor(.black)
                            .padding(.trailing, 4)
                        
                        Text(viewModel.selectedDate.formatted(.dateTime.day().month().year()))
                            .foregroundColor(.black)
                            .font(.Poppins.regular(size: 16))
                            .overlay {
                                DatePicker(selection: $viewModel.selectedDate, displayedComponents: .date) {}
                                    .labelsHidden()
                                    .contentShape(Rectangle())
                                    .opacity(0.011)
                            }
                        
                        Spacer()
                        
                    }
                    .padding(12)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(.linearGradient(colors: [.white, .white],
                                                  startPoint: .top,
                                                  endPoint: .bottomTrailing)))
                    .padding(.top, 8)
                    
                    Button {
                        viewModel.filterAirports(airports: airports)
                        viewModel.loadRoutes()
                        viewModel.selectionWasMade.toggle()
                    } label: {
                        Text("Show Results")
                            .font(.Poppins.regular(size: 14))
                            .padding(.all, 12)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                    }.padding(.top, 8)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .background(Color.accentMain)
                
                ScrollView(showsIndicators: false) {
                    switch viewModel.routesState {
                    case .failure(_):
                        ErrorView()
                    case .loading:
                        LoaderView()
                    case .value(let routes):
                        let prefix = viewModel.weekDay.lowercased().prefix(3)
                        let filteredRoutes = routes.filter { route in
                            route.days.contains(where: { day in
                                day.range(of: prefix, options: .caseInsensitive) != nil
                            })
                        }
                        
                        if filteredRoutes.count > 0 {
                            ForEach(filteredRoutes) { route in
                                let depAirport = viewModel.getAirport(icaoCode: route.depIcao, iataCode: route.depIata)!
                                let arrAirport = viewModel.getAirport(icaoCode: route.arrIcao, iataCode: route.arrIata) ?? Airport(name: "Henri Coanda International Airport", iataCode: "OTP", icaoCode: "LROP", latitude: 44.571476, longitude: 26.088081, countryCode: "RO")
                                let countryDep = viewModel.getCountryByAirport(airport: depAirport) ?? Country(countryCode: "RO",
                                                                                                               countryName: "Romania")
                                let countryArr = viewModel.getCountryByAirport(airport: arrAirport) ?? Country(countryCode: "RO",
                                                                                                               countryName: "Romania")
                                let routesViewModel = RoutesViewModel(route: route,
                                                                      weekDay: viewModel.weekDay,
                                                                      depAirport: depAirport,
                                                                      arrAirport: arrAirport,
                                                                      countryDep: countryDep,
                                                                      countryArr: countryArr,
                                                                      selectedDate: viewModel.selectedDate)
                                RoutesScreenView(viewModel: routesViewModel)
                            }
                        } else if routes.isEmpty {
                            ErrorView()
                        } else {
                            ForEach(routes) { route in
                                let defaultAirport = Airport(name: "Henri Coanda",
                                                             iataCode: "AA",
                                                             icaoCode: "AA4",
                                                             latitude: 44.439663,
                                                             longitude: 26.096306,
                                                             countryCode: "RO")
                                let depAirport = viewModel.getAirport(icaoCode: route.depIcao, iataCode: route.depIata) ?? defaultAirport
                                let arrAirport = viewModel.getAirport(icaoCode: route.arrIcao, iataCode: route.arrIata) ?? defaultAirport
                                let countryDep = viewModel.getCountryByAirport(airport: depAirport) ?? Country(countryCode: "RO",
                                                                                                               countryName: "Romania")
                                let countryArr = viewModel.getCountryByAirport(airport: arrAirport) ?? Country(countryCode: "RO",
                                                                                                               countryName: "Romania")
                                let routesViewModel = RoutesViewModel(route: route,
                                                                      weekDay: viewModel.weekDay,
                                                                      depAirport: depAirport,
                                                                      arrAirport: arrAirport,
                                                                      countryDep: countryDep,
                                                                      countryArr: countryArr,
                                                                      selectedDate: viewModel.selectedDate)
                                RoutesScreenView(viewModel: routesViewModel)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bgSecondary)
            }
        }
    }
}

fileprivate struct SearchField: View {
    @Binding var text: String
    var placeHolder: String
    var colors: (bgColor: Color, borderColor: Color, placeholderForeground: Color) = (.white, .white, .contentSecondary)
    var leftIcon: ImageResource
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
                    Image(leftIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        .foregroundColor(.black)
                        .padding(.trailing, 4)
                    
                    if $text.wrappedValue.isEmpty {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.Poppins.regular(size: 14))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.Poppins.regular(size: 14))
                            .scaleEffect(0.75, anchor: .leading)
                            .offset(y: -12)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Image(leftIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        .foregroundColor(.black)
                        .padding(.trailing, 4)
                        .opacity(0)
                    
                    TextField(text: $text) {
                    }
                    .foregroundColor(.black)
                    .font(.Poppins.regular(size: 14))
                    .offset(y: $text.wrappedValue.isEmpty ? 0 : 4 )
                }
            }
            .padding(.all, 12)
            .background(.white)
            .border(!isEditing ? colors.borderColor : .black, width: 1, cornerRadius: 0)
            .onTapGesture {
                self.isEditing = true
            }
            .onChange(of: text) { _ in
                self.isEditing = true
            }
            .onSubmit {
                self.isEditing = false
            }
        }
    }
}
