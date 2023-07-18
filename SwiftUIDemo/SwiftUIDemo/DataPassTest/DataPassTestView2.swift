//
//  DataPassTestView2.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

struct DataPassTestView2: View {
    
    //可以修改binding的数据，使得在各个view之间数据能同步
    @Binding var count: Int
    
    var body: some View {
        VStack {
            Text("count: \(count)").font(.title)
            Button(action: {
                count  = count - 1
            }) {
                Text("Minus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .navigationTitle(String(describing: Self.self))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataPassTestView2_Previews: PreviewProvider {
    static var previews: some View {
        DataPassTestView2(count: .constant(0))
    }
}
