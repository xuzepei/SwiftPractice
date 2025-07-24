//
//  NavigationStackDemoView.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/25.
//

import SwiftUI

struct NavigationTarget: Hashable {
    var type: String
    //var token: [String: AnyObject]? = nil
}

struct NavigationStackDemoView: View {
    
    @State private var shouldRefreshSet: Set<String> = []
    @State var path = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $path) {
            VStack {
                
                Button {
                    path.append(NavigationTarget(type: "testview1"))
                } label: {
                    Text("Go to TestView 1")
                }
                
            }
            .onAppear {
                print("#### will onAppear in \(NavigationStackDemoView.self)")
            }
            .navigationTitle("\(NavigationStackDemoView.self)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationTarget.self) { target in
                goToView(target: target)
            }
        }
        .onChange(of: shouldRefreshSet) { newValue in
            
            if newValue.contains("rootview") {
                print("#### will refresh in \(NavigationStackDemoView.self)")
                
                shouldRefreshSet.remove("rootview")
            }
        }

        
    }
    
    @ViewBuilder
    func goToView(target: NavigationTarget) -> some View {
        
        switch target.type {
        case "testview1":
            TestView1(shouldRefreshSet: $shouldRefreshSet, path: $path)
        case "testview2":
            TestView2(shouldRefreshSet: $shouldRefreshSet, path: $path)
        case "testview3":
            TestView3(shouldRefreshSet: $shouldRefreshSet, path: $path)
        default:
            EmptyView()
        }
    }
}

#Preview {
    NavigationStackDemoView()
}
