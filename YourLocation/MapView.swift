//
//  ContentView.swift
//  YourLocation
//
//  Created by piotr koscielny on 29/5/25.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Environment(LocationManager.self) private var locationManager
    @State private var cameraPosition: MapCameraPosition = .automatic
    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all)
            .ignoresSafeArea()
            .onChange(of: locationManager.location) { _ , newLocation in
                if let coord = newLocation {
                    withAnimation {
                        cameraPosition = .region(MKCoordinateRegion(
                            center: coord,
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
                    }
                }
            }
            .onAppear {
                locationManager.checkAuthorization()
                if let coord = locationManager.location {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: coord,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
                }
            }
    }
}

#Preview {
    MapView()
}
