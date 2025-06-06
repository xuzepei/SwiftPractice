//
//  SwiftUIDemoApp.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/14.
//

import SwiftUI

@main
struct SwiftUIDemoApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            //LandmarkContentView().environmentObject(modelData)
            
            //ContentView()
            LandmarkContentView().environmentObject(modelData)
                
        }
    }
}
