//
//  LandmarkDetail.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/14.
//

import SwiftUI
import UIKit

struct LandmarkDetail: View {
    
    var landmark: Landmark
    
    @State private var navigationBarHeight: CGFloat = 0
    @State private var mapViewBottom: CGFloat = 0
    
    
    var body: some View {
        ScrollView {
            
            MapView(landmark: landmark)
                .frame(height: 300)
                
            CircleImage(image: landmark.image)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text(landmark.name).font(.title).foregroundColor(.black)
                HStack {
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("About \(landmark.name)").font(.title2)
                Text(landmark.description)
                
            }.padding()
            
            Spacer()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .onAppear {
                    let topInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
                    let statusBarHeight = UIDevice.statusBarHeight()
                    self.navigationBarHeight = topInset + statusBarHeight
                    print("Navigation Bar Height: \(self.navigationBarHeight)")
                }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: landmarks[0])
            .previewDevice("iPhone 14 Pro")
    }
}
