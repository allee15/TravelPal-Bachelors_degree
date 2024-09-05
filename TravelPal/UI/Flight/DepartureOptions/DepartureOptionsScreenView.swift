//
//  DepartureOptionsScreenView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 07.08.2023.
//

import SwiftUI
import PassKit

struct DepartureOptionsScreenView: View {
    @StateObject var viewModel: DepartureOptionsViewModel
    @EnvironmentObject private var navigation: Navigation
    @State var showBottomSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.user != nil {
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
                    
                    TabView(selection: $viewModel.tabSelected) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 24) {
                                if viewModel.tabSelected == .flight {
                                    FlightView(route: viewModel.route,
                                               countryDep: viewModel.countryDep,
                                               countryArr: viewModel.countryArr,
                                               weekDay: viewModel.weekDay,
                                               countUsers: viewModel.countUsers)
                                    .padding(.top, 20)
                                } else {
                                    CarView(depAirport: viewModel.depAirport,
                                            arrAirport: viewModel.arrAirport,
                                            route: viewModel.route)
                                }
                                
                                BlackButtonView(text: "Check out with ApplePay",
                                                icon: .icAppleIconWhite) {
                                    switch viewModel.tabSelected {
                                    case .flight:
                                        viewModel.image = renderFromFlightView()
                                    case .car:
                                        viewModel.image = renderFromCarView()
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        self.showBottomSheet.toggle()
                                    }
                                }
                            }.padding(.horizontal, 20)
                                .padding(.top, 16)
                        }
                    }.tabViewStyle(PageTabViewStyle())
                    
                }
                    
            } else {
                UnloggedUserView()
            }
        }.background(Color.bgSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
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
            }.sheet(isPresented: $showBottomSheet) {
                PaymentSheetView(price: viewModel.route.duration * 2) {
                    let destinationVM = AccomodationViewModel(route: viewModel.route,
                                                              countryArr: viewModel.countryArr,
                                                              image: viewModel.image)
                    
                    navigation.presentPopup(LoaderViewWithBg().asDestination(), animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        navigation.dismissModal(animated: true, completion: nil)
                        navigation.push(AccomodationScreenView(viewModel: destinationVM).asDestination(),
                                        animated: true)
                    }
                } actionClose: {
                    navigation.dismissModal(animated: true, completion: nil)
                }.presentationDetents([.fraction(1/2)])
            }
    }
    
    func renderFromFlightView() -> Image? {
        let view = FlightView(route: viewModel.route,
                              countryDep: viewModel.countryDep,
                              countryArr: viewModel.countryArr,
                              weekDay: viewModel.weekDay,
                              countUsers: viewModel.countUsers)
        let renderer = ImageRenderer(content: view.body)
        if let image = renderer.cgImage {
            return Image(decorative: image, scale: 1)
        } else {
            return nil
        }
    }
    
    func renderFromCarView() -> Image? {
        let view = CarView(depAirport: viewModel.depAirport, arrAirport: viewModel.arrAirport, route: viewModel.route)
        let renderer = ImageRenderer(content: view.body)
        if let image = renderer.cgImage {
            return Image(decorative: image, scale: 1)
        } else {
            return nil
        }
    }
}


fileprivate struct FlightView: View {
    let route: Route
    let countryDep: Country
    let countryArr: Country
    let weekDay: String
    let countUsers: Int
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 0) {
                    
                    VStack(spacing: 0) {
                        Image(.icItemresultDeparture)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(route.depName)
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
                            .frame(height: 20)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(route.arrName)
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
                            .frame(height: 28)
                        
                        Spacer()
                    }
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Image(systemName: "rectangle.trailinghalf.filled")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .foregroundColor(.accentMain)
                            .padding(.trailing, 4)
                        
                        Text(countryDep.countryName)
                            .font(.Poppins.semiBold(size: 16))
                            .bold()
                            .foregroundColor(.accentMain)
                        
                        Spacer()
                        
                        Image(systemName: "rectangle.trailinghalf.filled")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .foregroundColor(.accentMain)
                            .padding(.trailing, 4)
                        
                        Text(countryArr.countryName)
                            .font(.Poppins.semiBold(size: 16))
                            .bold()
                            .foregroundColor(.accentMain)
                    }.padding(.all, 8)
                        .border(Color.contentSecondary.opacity(0.1), width: 1)
                    
                    HStack(spacing: 0) {
                        Image(.icCalendar)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.trailing, 4)
                        
                        Text("\(weekDay) \(route.depTimeUtc)")
                            .font(.Poppins.semiBold(size: 14))
                            .foregroundColor(.contentSecondary)
                        
                        Spacer()
                        
                        Image(.icCalendar)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.trailing, 4)
                        
                        Text("\(weekDay) \(route.arrTimeUtc)")
                            .font(.Poppins.semiBold(size: 14))
                            .foregroundColor(.contentSecondary)
                    }.padding(.all, 8)
                        .border(Color.contentSecondary.opacity(0.1), width: 1)
                    
                    HStack(spacing: 0) {
                        Image(.icItemresultTime)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.trailing, 4)
                        
                        Text("Duration: \(route.duration) minutes")
                            .font(.Poppins.regular(size: 14))
                            .foregroundColor(.contentSecondary)
                        
                        Spacer()
                        
                        Image(.icDollar)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.trailing, 4)
                        
                        Text("Price: \(route.duration * 2)€")
                            .font(.Poppins.regular(size: 14))
                            .foregroundColor(.contentSecondary)
                    }.padding(.all, 8)
                        .border(Color.contentSecondary.opacity(0.1), width: 1)
                    
                    HStack(spacing: 0) {
                        Text("Flight: \(route.flightIcao)")
                            .font(.Poppins.semiBold(size: 16))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                    }.padding(.all, 8)
                }
            }.padding(.horizontal, 12)
                .padding(.top, 16)
                .background(.white)
        }
    }
}

fileprivate struct CarView: View {
    @StateObject private var locationPermission = LocationPermissionViewModel()
    @State var showMap: Bool = false
    
    let depAirport: Airport
    let arrAirport: Airport
    let route: Route
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.imgMap)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.65)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    RedButtonView(text: "Show me directions") {
                        showMap.toggle()
                        locationPermission.viewDidLoad()
                    }
                    
                    RedButtonView(text: "Open Maps") {
                        let appleMapsUrl = (URL(string: "http://maps.apple.com/maps?q=\(route.arrName)"))
                        if UIApplication.shared.canOpenURL(appleMapsUrl!) {
                            UIApplication.shared.open(appleMapsUrl!)
                        }
                    }
                }
            }.background(Color.white)
            
        }.sheet(isPresented: $showMap) {
            MapCarView(latitudeDeparture: locationPermission.currentLocation?.coordinate.latitude ?? depAirport.latitude,
                       longitudeDeparture: locationPermission.currentLocation?.coordinate.longitude ?? depAirport.longitude,
                       latitudeArrival: arrAirport.latitude,
                       longitudeArrival: arrAirport.longitude)
            .presentationDetents([.fraction(2/3)])
        }
    }
}

fileprivate struct PaymentSheetView: View {
    let price: Int
    let action: () -> ()
    let actionClose: () -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    Image(.icApple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Pay")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Button {
                        actionClose()
                    } label: {
                        Image(.icClosePay)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .padding(.all, 10)
                            .background(
                                Circle()
                                    .fill(Color.contentSecondary.opacity(0.2))
                            )
                    }
                }.padding([.top, .horizontal], 12)
                
                HStack(spacing: 8) {
                    Image(.imgAppleCard)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Apple Card")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 18))
                        
                        Text("Lucretiu Patrascanu 4, Bucuresti")
                            .font(.system(size: 18))
                            .foregroundColor(.contentSecondary)
                    }
                    
                    Spacer()
                    
                    Image(.icItemresultArrow)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }.padding(.all, 12)
                    .background(.white)
                    .cornerRadius(6)
                    .padding(.all, 12)
                
                Spacer(minLength: 24)
            }.background(Color.bgSecondary)
            
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pay Apple Store")
                            .font(.system(size: 16))
                            .foregroundColor(.contentSecondary)
                        
                        Text("\(price)€")
                            .bold()
                            .foregroundStyle(Color.black)
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Image(.icItemresultArrow)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 8)
                }.padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.contentSecondary.opacity(0.2))
                    .padding(.bottom, 8)
                
                ApplePayButtonView {
                    action()
                }.padding(.top, 4)
                    .padding(.bottom, 12)
                
            }.background(.white)
                .cornerRadius(6)
        }
    }
}
