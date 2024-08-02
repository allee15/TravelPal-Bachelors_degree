//
//  DepartureOptionsScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 07.08.2023.
//

import SwiftUI
import Kingfisher

struct DepartureOptionsScreenView: View {
    @ObservedObject var viewModel: DepartureOptionsViewModel
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        if viewModel.user?.isAnonymous == false {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 8) {
                        BackButton()
                        
                        Text("Departure information")
                            .font(.Poppins.semiBold(size: 24))
                            .foregroundColor(.black)
                    }.padding(.vertical, 20)
                    
                    HStack(spacing: 16) {
                        TabButton(title: "Selected flight",
                                  isSelectedOn: .flight,
                                  selectedTab: viewModel.tabSelected) {
                            viewModel.tabSelected = .flight
                        }
                        
                        TabButton(title: "Car way",
                                  isSelectedOn: .car,
                                  selectedTab: viewModel.tabSelected) {
                            viewModel.tabSelected = .car
                        }
                        Spacer()
                    }
                }.padding(.horizontal, 15)
                    .background(Color.white)
                
                ScrollView(showsIndicators: false) {
                    if viewModel.tabSelected == .flight {
                        FlightView(depName: viewModel.route.depName,
                                   arrName: viewModel.route.arrName,
                                   countryDep: viewModel.countryDep,
                                   countryArr: viewModel.countryArr,
                                   weekDay: viewModel.weekDay,
                                   depTimeUtc: viewModel.route.depTimeUtc,
                                   arrTimeUtc: viewModel.route.arrTimeUtc,
                                   duration: viewModel.route.duration,
                                   flightIcao: viewModel.route.flightIcao,
                                   route: viewModel.route,
                                   countUsers: viewModel.countUsers)
                        .padding(.top, 20)
                    } else {
                        CarView(depAirportLatitude: viewModel.depAirport.latitude,
                                depAirportLongitude: viewModel.depAirport.longitude,
                                arrAirportLatitude: viewModel.arrAirport.latitude,
                                arrAirportLongitude: viewModel.arrAirport.longitude,
                                route: viewModel.route,
                                weekDay: viewModel.weekDay,
                                countryDep: viewModel.countryDep,
                                countryArr: viewModel.countryArr,
                                countUsers: viewModel.countUsers)
                    }
                }
            }.background(Color.bgSecondary)
                .onAppear {
                    let modal = ModalChooseOptionView(title: "Fly or Drive?",
                                                      description: "If you are flying, you can see your tichet flight details in this section. If you are driving, you can see some available routes. Choose the most suitable option for you!\nNote that you can always swap between the two options, using the tab menu.",
                                                      topButtonText: "Continue",
                                                      bottomButtonText: "Go back") {
                        navigation.dismissModal(animated: true, completion: nil)
                    } onBottomButtonTapped: {
                        navigation.dismissModal(animated: true, completion: nil)
                        navigation.pop(animated: true)
                    }
                    navigation.presentPopup(modal.asDestination(),
                                            animated: true,
                                            completion: nil)
                }
        } else {
            UnloggedUserView()
        }
    }
}

