//
//  TimelineCar.swift
//  TravelPal
//
//  Created by Aldea Alexia on 08.08.2023.
//

import SwiftUI
import MapKit
import Contacts

struct MapCarView: View {
    @State private var directions: [String] = []
    @State private var showDirections: Bool = false
    
    let latitudeDeparture: Double
    let longitudeDeparture: Double
    let latitudeArrival: Double
    let longitudeArrival: Double
    
    var body: some View {
        VStack {
            MapView(directions: $directions,
                    latitudeDeparture: latitudeDeparture,
                    longitudeDeparture: longitudeDeparture,
                    latitudeArrival: latitudeArrival,
                    longitudeArrival: longitudeArrival)
            
            BlackButtonView(text: "Show directions", isDisabled: directions.isEmpty) {
                self.showDirections.toggle()
            }.padding(.all, 16)
        }.background(Color.white)
        .sheet(isPresented: $showDirections) {
            VStack(spacing: 0) {
                Text("Directions")
                    .font(.Poppins.bold(size: 28))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                
                Divider()
                    .background(Color.contentSecondary)
                    .frame(height: 2)
                    .padding(.trailing, 8)
                
                ScrollView(showsIndicators: false, content: {
                    VStack(spacing: 0) {
                        ForEach(0..<self.directions.count, id: \.self) { index in
                            VStack(spacing: 0) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.accentMain)
                                
                                HStack {
                                    Text(self.directions[index])
                                        .foregroundColor(.black)
                                        .font(.Poppins.regular(size: 16))
                                        .multilineTextAlignment(.leading)
                                        .padding(.vertical, 16)
                                    Spacer()
                                }
                            }
                        }
                    }.padding(.horizontal, 16)
                })
            }.background(Color.white)
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var directions: [String]
    
    let latitudeDeparture: Double
    let longitudeDeparture: Double
    let latitudeArrival: Double
    let longitudeArrival: Double
    
    typealias UIViewType = MKMapView
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitudeDeparture,
                                                                       longitude: longitudeDeparture),
                                        span: MKCoordinateSpan(latitudeDelta: 0.5,
                                                               longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        let departure = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudeDeparture,
                                                                       longitude: longitudeDeparture),
                                    addressDictionary: [CNPostalAddressStreetKey: "Departure location"])
        
        let arrival = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudeArrival,
                                                                     longitude: longitudeArrival),
                                  addressDictionary: [CNPostalAddressStreetKey: "Arrival location"])
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: departure)
        request.destination = MKMapItem(placemark: arrival)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([departure,arrival])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                      edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                                      animated: true)
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

