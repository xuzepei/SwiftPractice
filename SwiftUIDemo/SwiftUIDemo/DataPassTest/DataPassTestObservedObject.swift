//
//  DataPassTestObservedObject.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

class UserData: ObservableObject {
    @Published var name = "John"
    @Published var age = 30
}

struct DataPassTestObservedObject: View {
    
    @ObservedObject var userData:UserData
    
    var body: some View {
        VStack {
            Text("Name: \(userData.name)")
            Text("Age: \(userData.age)")
            
            NavigationLink(destination: DataPassTestChangeObservedObject(userData: userData)) {
                Text("Go to change")
                    //.font(.title2)
                    .foregroundColor(.blue)
            }.padding()
        }
    }
}
