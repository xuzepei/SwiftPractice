//
//  LandmarkDetail.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/14.
//

import SwiftUI
import UIKit

struct LandmarkDetail: View {
    
    @EnvironmentObject var modelData: ModelData
    var landmark: Landmark
    
    @State private var navigationBarHeight: CGFloat = 0
    @State private var mapViewBottom: CGFloat = 0
    
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }
    
    
    var body: some View {
        ScrollView {
            
            MapView(landmark: landmark)
                .frame(height: 300)
                
            CircleImage(image: landmark.image)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                }
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
    
    static let modelData = ModelData()
    
    static var previews: some View {
        LandmarkDetail(landmark: modelData.landmarks[0])
            .environmentObject(modelData)
            .previewDevice("iPhone 14 Pro")
    }
}
