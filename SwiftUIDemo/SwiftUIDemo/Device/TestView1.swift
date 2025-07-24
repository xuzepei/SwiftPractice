//
//  TestView1.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/25.
//

import SwiftUI

struct TestView1: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var shouldRefreshSet: Set<String>
    @Binding var path: NavigationPath
    
    var body: some View {
        
        VStack {
            Button {
                path.append(NavigationTarget(type: "testview2"))
            } label: {
                Text("Go to TestView 2")
            }
            
        }
        .onAppear {
            print("#### will onAppear in \(TestView1.self)")
        }
        .onChange(of: shouldRefreshSet) { newValue in
            if newValue.contains("testview1") {
                print("#### will refresh in \(TestView1.self)")
                shouldRefreshSet.remove("testview1")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("\(TestView1.self)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // 左边返回按钮
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    shouldRefreshSet.insert("rootview")
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                }
            }
        }
    }
}

#Preview {
    //TestView1()
}
