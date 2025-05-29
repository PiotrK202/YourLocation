//
//  ContentView.swift
//  YourLocation
//
//  Created by piotr koscielny on 29/5/25.
//

import MapKit
import SwiftUI

struct MapView: View {
    var body: some View {
        Map()
            .mapStyle(.hybrid(elevation: .realistic))
    }
}

#Preview {
    MapView()
}
