//
//  DataPassTestState.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

struct DataPassTestState: View {
    
    //使用 @State private var 属性包装器可以在视图内部存储和管理状态
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("count: \(count)").font(.title)
            Button(action: {
                count  = count + 1
            }) {
                Text("Add")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }.padding()
            
            NavigationLink(destination: DataPassTestBinding(count: $count)) {
                Text("Go to DataPassTestBinding")
                    .font(.title2)
                    .foregroundColor(.blue)
            }.padding()
        }
        .navigationTitle(String(describing: Self.self))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataPassTestState_Previews: PreviewProvider {
    static var previews: some View {
        DataPassTestState()
    }
}
