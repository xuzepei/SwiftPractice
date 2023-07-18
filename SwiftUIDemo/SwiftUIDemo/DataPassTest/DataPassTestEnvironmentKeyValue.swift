//
//  DataPassTestEnvironmentKeyValue.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

struct Settings {
    var theme: String
    var fontSize: Int
}

struct SettingsKey: EnvironmentKey {
    static let defaultValue = Settings(theme: "Light", fontSize: 16)
}

extension EnvironmentValues {
    var settings: Settings {
        get { self[SettingsKey.self] }
        set { self[SettingsKey.self] = newValue }
    }
}

struct DataPassTestEnvironmentKeyValue: View {
    
    @Environment(\.settings) var settings
    
    var body: some View {
        VStack {
            Text("Theme: \(settings.theme)")
            Text("Font size: \(settings.fontSize)")
            
            NavigationLink(destination: DataPassTestChangeEnvironmentKeyValue()) {
                Text("Go to change")
                    //.font(.title2)
                    .foregroundColor(.blue)
            }.padding()
        }
    }
}

