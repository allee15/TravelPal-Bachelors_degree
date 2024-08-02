//
//  TimelineFlight.swift
//  TravelPal
//
//  Created by Aldea Alexia on 08.08.2023.
//

import SwiftUI

struct FlightView: View {
    @EnvironmentObject private var navigation: Navigation
    @State var showBottomSheet: Bool = false
    @State var image: Image?
    
    @State var depName: String
    @State var arrName: String
    @State var countryDep: Country
    @State var countryArr: Country
    @State var weekDay: String
    @State var depTimeUtc: String
    @State var arrTimeUtc: String
    @State var duration: Int
    @State var flightIcao: String
    @State var route: Route
    @State var countUsers: Int
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 0) {
                    
                    VStack(spacing: 0) {
                        Image("ic_itemresult_departure")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(depName)
                            .font(.Poppins.bold(size: 20))
                            .foregroundColor(.black)
                        
                        Text("Departure")
                            .font(.Poppins.regular(size: 12))
                            .foregroundColor(.black)
                    }.padding(.leading, 4)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Image("ic_itemresult_arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(arrName)
                            .bold()
                            .font(.Poppins.bold(size: 20))
                            .foregroundColor(.black)
                        
                        Text("Arrival")
                            .font(.Poppins.regular(size: 12))
                            .foregroundColor(.black)
                    }.padding(.trailing, 4)
                    
                    VStack(spacing: 0) {
                        Image("ic_itemresult_destination")
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
                        Image("ic_calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.trailing, 4)
                        
                        Text("\(weekDay) \(depTimeUtc)")
                            .font(.Poppins.semiBold(size: 14))
                            .foregroundColor(.contentSecondary)
                        
                        Spacer()
                        
                        Image("ic_calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.trailing, 4)
                        
                        Text("\(weekDay) \(arrTimeUtc)")
                            .font(.Poppins.semiBold(size: 14))
                            .foregroundColor(.contentSecondary)
                    }.padding(.all, 8)
                        .border(Color.contentSecondary.opacity(0.1), width: 1)
                    
                    HStack(spacing: 0) {
                        Image("ic_itemresult_time")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.trailing, 4)
                        
                        Text("Duration: \(duration) minutes")
                            .font(.Poppins.regular(size: 14))
                            .foregroundColor(.contentSecondary)
                        
                        Spacer()
                        
                        Image("ic_dollar")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.trailing, 4)
                        
                        Text("Price: \(duration * 2)€")
                            .font(.Poppins.regular(size: 14))
                            .foregroundColor(.contentSecondary)
                    }.padding(.all, 8)
                        .border(Color.contentSecondary.opacity(0.1), width: 1)
                    
                    HStack(spacing: 0) {
                        Text("Flight: \(flightIcao)")
                            .font(.Poppins.semiBold(size: 16))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                    }.padding(.all, 8)
                }
            }.padding(.horizontal, 12)
                .padding(.vertical, 16)
                .background(.white)
            
            PaymentButton {
                self.image = render()
                showBottomSheet = true
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .sheet(isPresented: $showBottomSheet) {
            BottomSheetView(image: image,
                            route: route,
                            weekDay: weekDay,
                            countryDep: countryDep,
                            countryArr: countryArr,
                            countUsers: countUsers,
                            price: duration * 2)
            .presentationDetents([.fraction(2/4)])
        }
    }
    
    func render() -> Image? {
        let renderer = ImageRenderer(content: self.body)
        if let image = renderer.cgImage {
            print("yeeee")
            print("\(image.height)")
            return Image(decorative: image, scale: 1)
        } else {
            return nil
        }
    }
}

