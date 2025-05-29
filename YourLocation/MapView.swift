//
//  ContentView.swift
//  YourLocation
//
//  Created by piotr koscielny on 29/5/25.
//
import SwiftUI
import MapKit
import UIKit

struct MapView: View {
    @Bindable var locationManager: LocationManager
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var searchText = ""
    private let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition, interactionModes: .all) {
                if let coordinate = locationManager.location {
                    Annotation("your location", coordinate: coordinate) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 15, height: 15)
                                .shadow(radius: 3)
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 15, height: 15)
                        }
                    }
                }
            }
            
            .mapStyle(.hybrid(elevation: .realistic))
            .ignoresSafeArea()
            .onChange(of: locationManager.location) { _, newLocation in
                if let coordinate = newLocation {
                    withAnimation {
                        cameraPosition = .region(MKCoordinateRegion(center: coordinate, span: span))
                    }
                }
            }
            .searchable(text: $searchText)
            .onAppear {
                locationManager.checkAuthorization()
                if let coordinate = locationManager.location {
                    cameraPosition = .region(MKCoordinateRegion(center: coordinate,span: span))
                }
            }
            
            .onSubmit(of: .search) {
                Task {
                    if let coordinate = await locationManager.searchLocation(name: searchText) {
                        withAnimation {
                            cameraPosition = .region(MKCoordinateRegion(center: coordinate,span: span))
                        }
                    }
                }
            }
            VStack {
                Spacer()
                Button {
                    if let coordinate = locationManager.location {
                        withAnimation {
                            cameraPosition = .region(MKCoordinateRegion(
                                center: coordinate,
                                span: span))
                        }
                    }
                } label: {
                    Label("show my location", systemImage: "location.fill")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 30)
            }
        }
        .alert("you need to allow location", isPresented: $locationManager.showDeniedAlert) {
            Button("Settings") {
                if let url = URL(string:  UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            Button("exit") {
                exit(0)
            }
        } message: {
            Text("you have to give location permission to use this app")
        }
    }
}
