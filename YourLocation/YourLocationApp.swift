//
//  YourLocationApp.swift
//  YourLocation
//
//  Created by piotr koscielny on 29/5/25.
//

import SwiftUI

@main
struct YourLocationApp: App {
    @State private var  locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            MapView()
                .environment(locationManager)
        }
    }
}
