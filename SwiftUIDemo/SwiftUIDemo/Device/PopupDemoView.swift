//
//  PopupDemoView.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/12.
//

import SwiftUI

struct PopupDemoView: View {
    @State private var showPopup = false

        var body: some View {
            ZStack {
                VStack {
                    Button("显示弹窗") {
                        showPopup = true
                    }
                }

                if showPopup {
                    Color.black.opacity(0.4) // 半透明背景
                        .ignoresSafeArea()
                        .onTapGesture { showPopup = false }

                    VStack(spacing: 16) {
                        Text("这是一个弹出视图")
                            .font(.headline)
                        Button("关闭") {
                            showPopup = false
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                    .frame(maxWidth: 300)
                }
            }
            .animation(.easeInOut, value: showPopup)
        }
}

#Preview {
    PopupDemoView()
}
