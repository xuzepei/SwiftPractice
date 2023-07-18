//
//  DataPassTestChangeEnvironmentKeyValue.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

struct DataPassTestChangeEnvironmentKeyValue: View {
    @Environment(\.settings) var settings
    
    var body: some View {
        
        VStack {
            Button("Change theme") {

            }
        }.environment(\.settings.theme,"Dark")
        .environment(\.settings.fontSize,66)
    }
}
