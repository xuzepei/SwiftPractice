//
//  MapView.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/14.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    var landmark: Landmark
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()

    
    var body: some View {

        Map(coordinateRegion: $region)
            .ignoresSafeArea()
            .onAppear {
                setRegion(landmark.locationCoordinate)
            }
        
        //Map(initialPosition: .region(region))
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

#Preview {
    let landmarks = ModelData().landmarks
    MapView(landmark: landmarks[0])
}
