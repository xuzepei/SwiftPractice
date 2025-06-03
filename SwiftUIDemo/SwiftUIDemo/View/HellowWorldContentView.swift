//
//  HellowWorldContentView.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/3.
//

import SwiftUI

struct HellowWorldContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.red)
            Text("Turtle Rock").font(.title)
                //.foregroundColor(.systemGreen)
            HStack {
                Text("Joshua Tree National Park").font(.subheadline)
                Spacer()
                Text("California").font(.subheadline)
            }
        }
        .padding()
        .background(Color.systemGray6)
        
    }
}

#Preview {
    HellowWorldContentView()
}
