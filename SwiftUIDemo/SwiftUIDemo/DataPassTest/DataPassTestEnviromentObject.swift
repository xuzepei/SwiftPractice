//
//  DataPassTestEnviromentObject.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published
    var theme: String = "Light"
    var username: String = "oldname"
}

struct DataPassTestEnviromentObject: View {
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack {
            Text("Current theme: \(settings.theme)")
            Text("Username: \(settings.username)")
            
            NavigationLink(destination: DataPassTestChangeEnviromentObject().environmentObject(settings)) {
                Text("Go to change")
                    //.font(.title2)
                    .foregroundColor(.blue)
            }.padding()
        }
        

    }
}
