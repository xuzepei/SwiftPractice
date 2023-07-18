//
//  DataPassTestChangeObservedObject.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

struct DataPassTestChangeObservedObject: View {
    
    @ObservedObject var userData: UserData
    
    var body: some View {
        Button("Change data") {
            userData.name = "Xu"
            userData.age = 40
        }
    }
}
