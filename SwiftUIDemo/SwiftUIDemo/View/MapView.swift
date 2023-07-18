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
    
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        //        Map(coordinateRegion: $region)
        //            .onAppear {
        //                setRegion(coordinate)
        //            }
        
        Map(coordinateRegion: $region, annotationItems: [landmark]) { annotation in
            MapPin(coordinate: annotation.locationCoordinate)
        }.onAppear {
            setRegion(landmark.locationCoordinate)
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(landmark: ModelData().landmarks[0])
    }
}
