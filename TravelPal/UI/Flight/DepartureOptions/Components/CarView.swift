//
//  CarView.swift
//  TravelPal
//
//  Created by Aldea Alexia on 18.01.2024.
//

import SwiftUI
import Kingfisher

struct CarView: View {
    @StateObject private var locationPermission = LocationPermissionViewModel()
    @State var showMap: Bool = false
    @State var showBottomSheet: Bool = false
    @State var image: Image?
    
    @State var depAirportLatitude: Double
    @State var depAirportLongitude: Double
    @State var arrAirportLatitude: Double
    @State var arrAirportLongitude: Double
    @State var route: Route
    @State var weekDay: String
    @State var countryDep: Country
    @State var countryArr: Country
    @State var countUsers: Int
    
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
                }.padding(.bottom, 24)
                
                PaymentButton {
                    self.image = render()
                    showBottomSheet = true
                }
            }.padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
            
        }.sheet(isPresented: $showMap) {
            MapCarView(latitudeDeparture: locationPermission.currentLocation?.coordinate.latitude ?? depAirportLatitude,
                       longitudeDeparture: locationPermission.currentLocation?.coordinate.longitude ?? depAirportLongitude,
                       latitudeArrival: arrAirportLatitude,
                       longitudeArrival: arrAirportLongitude)
            .presentationDetents([.fraction(2/3)])
        }
        .sheet(isPresented: $showBottomSheet) {
            BottomSheetView(image: image,
                            route: route,
                            weekDay: weekDay,
                            countryDep: countryDep,
                            countryArr: countryArr,
                            countUsers: countUsers, 
                            price: 50)
            .presentationDetents([.fraction(2/4)])
        }
    }
    
    func render() -> Image? {
        let renderer = ImageRenderer(content: self.body)
        if let image = renderer.cgImage {
            return Image(decorative: image, scale: 1)
        } else {
            return nil
        }
    }
}

