//
//  TestView2.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/25.
//

import SwiftUI

struct TestView2: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var shouldRefreshSet: Set<String>
    @Binding var path: NavigationPath
    
    var body: some View {
        
        VStack {
            Button {
                path.append(NavigationTarget(type: "testview3"))
            } label: {
                Text("Go to TestView 3")
            }
            
        }
        .onAppear {
            print("#### will onAppear in \(TestView2.self)")
        }
        .onChange(of: shouldRefreshSet) { newValue in
            if newValue.contains("testview2") {
                print("#### will refresh in \(TestView2.self)")
                shouldRefreshSet.remove("testview2")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("\(TestView2.self)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // 左边返回按钮
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    shouldRefreshSet.insert("testview1")
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                }
            }
        }
    }
}

#Preview {
    //TestView2()
}
