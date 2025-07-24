//
//  TestView3.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/25.
//

import SwiftUI

struct TestView3: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var shouldRefreshSet: Set<String>
    @Binding var path: NavigationPath
    
    var body: some View {
        
        VStack {
            Button {
                shouldRefreshSet.insert("rootview")
                path.removeLast(path.count)
            } label: {
                Text("Back to root view")
            }
            
        }
        .onAppear {
            print("#### will onAppear in \(TestView3.self)")
        }
        .onChange(of: shouldRefreshSet) { newValue in
            if newValue.contains("testview3") {
                print("#### will refresh in \(TestView3.self)")
                shouldRefreshSet.remove("testview3")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("\(TestView3.self)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // 左边返回按钮
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    shouldRefreshSet.insert("rootview")
                    path.removeLast(path.count)
                } label: {
                    Image(systemName: "arrow.backward")
                }
            }
        }
    }
}

#Preview {
    //TestView3()
}
