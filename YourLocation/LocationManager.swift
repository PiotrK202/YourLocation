//
//  LocationManager.swift
//  YourLocation
//
//  Created by piotr koscielny on 29/5/25.
//

import Foundation
import CoreLocation
import Observation
import MapKit

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var authorizathioneStatus: CLAuthorizationStatus = .notDetermined
    var showDeniedAlert = false
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func searchLocation(name: String) async -> CLLocationCoordinate2D? {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name
        
        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start()
            return response.mapItems.first?.placemark.coordinate
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func checkAuthorization() {
        let status = locationManager.authorizationStatus
        authorizathioneStatus = status
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showDeniedAlert = true
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        abs(lhs.latitude - rhs.latitude) < 0.0001 &&
        abs(lhs.longitude - rhs.longitude) < 0.0001
    }
}
