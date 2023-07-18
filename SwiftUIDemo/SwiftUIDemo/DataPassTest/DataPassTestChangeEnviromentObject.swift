//
//  DataPassTestChangeEnviromentObject.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

struct DataPassTestChangeEnviromentObject: View {
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        Button("Switch theme") {
            settings.theme = "Dark"
            settings.username = "newname"
        }
    }
}
