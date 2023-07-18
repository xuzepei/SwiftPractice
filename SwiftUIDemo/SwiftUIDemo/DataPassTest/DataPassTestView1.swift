//
//  DataPassTestView1.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

struct DataPassTestView1: View {
    
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
            
            NavigationLink(destination: DataPassTestView2(count: $count)) {
                Text("Go to DataPassTestView2")
                    .font(.title2)
                    .foregroundColor(.blue)
            }.padding()
        }
        .navigationTitle(String(describing: Self.self))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataPassTestView1_Previews: PreviewProvider {
    static var previews: some View {
        DataPassTestView1()
    }
}
