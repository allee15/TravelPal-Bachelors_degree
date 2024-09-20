//
//  LocationPermissionViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 09.08.2023.
//

import Foundation
import CoreLocation
import UIKit

class LocationPermissionViewModel: UIViewController, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    private func locacationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    locationManager?.startUpdatingLocation()
                }
            }
        }
    }
    
    private func locationManagerSaveLocation(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
        }
    }
}
