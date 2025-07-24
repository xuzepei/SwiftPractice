//
//  NavigationContentView.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/10.
//

import SwiftUI

struct AddDeviceView: View {
    var body: some View {
        Text("添加设备")
    }
}

struct AnotherView: View {
    var body: some View {
        Text("其他页面")
    }
}

struct NavigationContentView: View {
    @Environment(\.presentationMode) var presentationMode
        @State private var goToViewIndex: Int? = nil
        @State private var isActive = false

        let actionOptions = ["添加设备", "查看其他"]

    var body: some View {
        NavigationView {
            VStack {
                Text("首页内容")
                
                // 隐藏跳转链接（用 Int? 控制）
                NavigationLink(destination: destinationView(), isActive: $isActive) {
                    //EmptyView()
                }
            }
            .navigationBarTitle("设备管理", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        //presentationMode.wrappedValue.dismiss()
                    }) {
                        //Image(systemName: "chevron.left")
                    },
                trailing:
                    Menu {
                        ForEach(actionOptions.indices, id: \.self) { index in
                            Button(action: {
                                goToViewIndex = index
                                isActive = true
                            }) {
                                Text(actionOptions[index])
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                    }
            )
        }
    }
    
    // 返回目标视图
    @ViewBuilder
    private func destinationView() -> some View {
        switch goToViewIndex {
        case 0:
            AddDeviceView()
        case 1:
            AnotherView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    NavigationContentView()
}
