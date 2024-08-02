//
//  FlightDetailsCardView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 04.08.2023.
//

import SwiftUI

struct RoutesScreenView: View {
    @ObservedObject var viewModel: RoutesViewModel
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        Button {
            let departureOptionsViewModel = DepartureOptionsViewModel(route: viewModel.route,
                                                                      weekDay: viewModel.weekDay,
                                                                      address: viewModel.route.arrName,
                                                                      depAirport: viewModel.depAirport!,
                                                                      arrAirport: viewModel.arrAirport!,
                                                                      countryDep: viewModel.countryDep,
                                                                      countryArr: viewModel.countryArr,
                                                                      countUsers: viewModel.countUsers,
                                                                      selectedDate: viewModel.selectedDate)
            navigation.push(DepartureOptionsScreenView(viewModel: departureOptionsViewModel).asDestination(),
                            animated: true)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 0) {
                    
                    VStack(spacing: 0) {
                        Image(.icItemresultDeparture)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.route.depIata)
                            .font(.Poppins.bold(size: 20))
                            .foregroundColor(.black)
                        
                        Text("Departure")
                            .font(.Poppins.regular(size: 12))
                            .foregroundColor(.black)
                    }.padding(.leading, 4)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Image(.icItemresultArrow)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(viewModel.route.arrIata)
                            .bold()
                            .font(.Poppins.bold(size: 20))
                            .foregroundColor(.black)
                        
                        Text("Arrival")
                            .font(.Poppins.regular(size: 12))
                            .foregroundColor(.black)
                    }.padding(.trailing, 4)
                    
                    VStack(spacing: 0) {
                        Image(.icItemresultDestination)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                        
                        Spacer()
                    }
                }
                
                HStack(spacing: 0) {
                    Image(.icItemresultTime)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                        .padding(.trailing, 4)
                    
                    Text("Take off \(viewModel.route.depTimeUtc)")
                        .font(.Poppins.regular(size: 14))
                        .foregroundColor(Color.contentSecondary)
                    
                    Spacer()
                    
                    Image(.icItemresultTime)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                        .padding(.trailing, 4)
                    
                    Text("Landing \(viewModel.route.arrTimeUtc)")
                        .font(.Poppins.regular(size: 14))
                        .foregroundColor(Color.contentSecondary)
                }.padding(.all, 8)
                    .border(Color.contentSecondary.opacity(0.1), width: 1)
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    Image(.icItemresultPersons)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                        .padding(.trailing, 4)
                    
                    Text("\(viewModel.countUsers)")
                        .font(.Poppins.regular(size: 14))
                        .foregroundColor(Color.contentSecondary)
                        .padding(.trailing, 16)
                    
                    Button {
                        let departureOptionsViewModel = DepartureOptionsViewModel(route: viewModel.route,
                                                                                  weekDay: viewModel.weekDay,
                                                                                  address: viewModel.route.arrName,
                                                                                  depAirport: viewModel.depAirport!,
                                                                                  arrAirport: viewModel.arrAirport!,
                                                                                  countryDep: viewModel.countryDep,
                                                                                  countryArr: viewModel.countryArr,
                                                                                  countUsers: viewModel.countUsers,
                                                                                  selectedDate: viewModel.selectedDate)
                        navigation.push(DepartureOptionsScreenView(viewModel: departureOptionsViewModel).asDestination(), 
                                        animated: true)
                    } label: {
                        Text("See details >")
                            .font(.Poppins.semiBold(size: 14))
                            .foregroundColor(Color.accentMain)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(.white)
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
}


